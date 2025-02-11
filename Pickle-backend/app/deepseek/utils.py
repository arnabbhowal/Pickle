from openai import OpenAI
import json
from app.config import DEEPSEEK_API_KEY  # Load API key

def get_movies_from_description_using_deepseek(description, exclude_list):
    
    try:
        client = OpenAI(api_key=DEEPSEEK_API_KEY, base_url="https://api.deepseek.com")

        # Construct the prompt
        prompt = (
            f"Provide a JSON array of exactly 10 real movies that match this description: '{description}'. "
            "The movies must be real, well-known, and sourced from actual movie databases like IMDb. "
            "Each entry in the JSON array should include: "
            "1. 'movie': The exact title of the movie. "
            "2. 'release_date': The official release date in 'YYYY-MM-DD' format. "
            "3. 'intro': A short, one-sentence summary of the movie. "
            "Ensure the response contains only a valid JSON array, with no additional text, formatting, or explanations. "
            "Do not include any fictional or AI-generated movies—only widely recognized real films."
        )

        # Add exclusion list to the prompt only if it's not empty
        if exclude_list and exclude_list.strip():
            prompt += (
                f" **Important:** Do not include any of the following movies in the suggestions: {exclude_list}. "
                "If any of these movies match the description, exclude them and suggest other movies instead."
            )

        # Call the DeepSeek API
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": "You are a brilliant movie critic who likes to suggest movies to users."},
                {"role": "user", "content": prompt}
            ],
            stream=False
        )

        # Extract the response content
        response_text = response.choices[0].message.content.strip()

        # Remove Markdown-style code blocks (```json ... ```)
        if response_text.startswith("```json"):
            response_text = response_text[7:-3].strip()
        elif response_text.startswith("```"):
            response_text = response_text[3:-3].strip()

        # Parse the response as JSON
        try:
            movies = json.loads(response_text)
            if isinstance(movies, list):
                # Validate the structure of each movie entry
                for movie in movies:
                    if not all(key in movie for key in ["movie", "release_date", "intro"]):
                        return {"error": "Invalid movie structure in DeepSeek response", "response": movies}
                return movies
            else:
                return {"error": "DeepSeek response is not a list", "response": movies}
        except json.JSONDecodeError:
            return {"error": "Failed to parse JSON from DeepSeek response", "response": response_text}

    except Exception as e:
        return {"error": str(e)}

def generate_itinerary_using_deepseek(destination, duration, interests, budget, exclude):
    try:
        # client = OpenAI(
        #     api_key=DEEPSEEK_API_KEY,
        #     base_url="https://api.deepseek.com/v1",
        #     timeout=30,
        #     default_headers={
        #         "User-Agent": "YourApp/1.0",
        #         "Accept": "application/json"
        #     }
        # )
        client = OpenAI(api_key=DEEPSEEK_API_KEY, base_url="https://api.deepseek.com")


        print(f"API Key: {'valid' if DEEPSEEK_API_KEY.startswith('sk-') else 'invalid'} ({DEEPSEEK_API_KEY[:8]}...)")
        
        prompt = f"""
        [Role]: You are an expert travel planner.
        [Task] Create a {duration}-day itinerary for {destination} with:
        - Interests: {interests}
        - Budget: {budget or 'medium'}
        - Exclude: {exclude or 'no restrictions'}
        
        [Format] JSON array with daily details including:
        "day", "date", "activities", "area_to_stay", "transportation"
        
        [Instructions]:
        - For "area_to_stay", suggest the best neighborhood (3 at max), district, or area to stay in for that day, based on the activities planned.
        - Do not recommend specific hotels or accommodations—only general areas.
        - Ensure the areas suggested are safe, convenient, and align with the traveler's interests and budget.
        """
        
        print(f"\n=== DeepSeek Prompt ===\n{prompt}\n======================\n")
        
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": "You are a professional travel planner."},
                {"role": "user", "content": prompt}
            ]
        )
        
        response_text = response.choices[0].message.content.strip()
        if response_text.startswith("```json"):
            response_text = response_text.replace("```json", "").replace("```", "").strip()
            
        print(f"\n=== DeepSeek response ===\n{response_text}\n======================\n")

        itinerary = json.loads(response_text)
        if isinstance(itinerary, list):
            required_keys = ["day", "activities", "area_to_stay", "transportation"]
            for day_plan in itinerary:
                if not all(key in day_plan for key in required_keys):
                    return {"error": "Invalid itinerary structure"}
            return itinerary
        return {"error": "Response was not a list", "response": response_text}

    except Exception as e:
        return {"error": str(e)}


def create_schedule_using_deepseek(calendar_events, tasks, physical_activities):
    try:
        client = OpenAI(api_key=DEEPSEEK_API_KEY, base_url="https://api.deepseek.com")

        # Construct the prompt for DeepSeek
        prompt = (
            f"Generate a daily schedule for the user based on the following inputs:\n\n"
            f"**Calendar Events:**\n{json.dumps(calendar_events, indent=2)}\n\n"
            f"**Tasks:**\n{json.dumps(tasks, indent=2)}\n\n"
            f"**Physical Activities:**\n{json.dumps(physical_activities, indent=2)}\n\n"
            "The schedule should:\n"
            "1. Prioritize tasks and activities based on their importance and deadlines.\n"
            "2. Allocate time for physical activities to ensure a healthy balance.\n"
            "3. Avoid conflicts with existing calendar events.\n"
            "4. Be realistic and consider the duration of each task/activity.\n"
            "5. Include breaks and buffer time between tasks.\n\n"
            "Return the schedule as a well written string"
        )

        # Call the DeepSeek API
        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": "You are a brilliant personal assistant who creates optimized schedules for users."},
                {"role": "user", "content": prompt}
            ],
            stream=False
        )

        # Extract the response content
        response_text = response.choices[0].message.content.strip()

        return response_text

    except Exception as e:
        return {"error": str(e)}
def get_meal_suggestions_using_deepseek(ingredients: list, preferences: str = "", calorie: int = None, protein: int = None):
    try:
        client = OpenAI(api_key=DEEPSEEK_API_KEY, base_url="https://api.deepseek.com")
        
        nutrition_rules = ""
        if calorie:
            nutrition_rules += f"- Maximum {calorie} calories per serving\n"
        if protein:
            nutrition_rules += f"- Minimum {protein}g protein per serving\n"

        prompt = f"""
        [Role]: You are a nutritionist and meal planning expert
        [Task]: Create 3 healthy meal suggestions using these ingredients: {', '.join(ingredients)}
        
        [Parameters]:
        - Preferences: {preferences if preferences else 'No restrictions'}
        {nutrition_rules if nutrition_rules else '- No specific nutrition requirements'}
        
        [Format]: JSON array with:
        - meal_name
        - ingredients_needed (mark which are available)
        - missing_ingredients
        - nutrition_info (calories, protein)
        - cooking_instructions
        - dietary_tags (vegan/gluten-free/etc)
        
        [Rules]:
        - Prioritize whole foods and fresh ingredients
        - Include storage/prep tips for ingredients
        - Flag any allergy concerns
        - Estimate cooking time
        """
        print(f"\n=== DeepSeek Prompt for meal suggestion ===\n{prompt}\n======================\n")

        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": "You are a professional nutritionist creating healthy meal plans."},
                {"role": "user", "content": prompt}
            ]
        )
        
        response_text = response.choices[0].message.content.strip()
        if response_text.startswith("```json"):
            response_text = response_text[7:-3].strip()
        elif response_text.startswith("```"):
            response_text = response_text[3:-3].strip()

        print(f"\n=== DeepSeek response for meal suggestion ===\n{response_text}\n======================\n")

        try:
            meals = json.loads(response_text)
            if isinstance(meals, list):
                return {"meal_suggestions": meals}
            return {"error": "Invalid response format", "response": response_text}
        except json.JSONDecodeError as e:
            print(f"JSON Decode Error: {str(e)}")
            print(f"Raw Response: {response_text}")
            return {"error": f"Failed to parse JSON: {str(e)}", "response": response_text}

    except Exception as e:
        return {"error": str(e)}
