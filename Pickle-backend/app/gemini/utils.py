import google.generativeai as genai
import json
from app.config import GEMINI_API_KEY


# Load the API key from environment variables
genai.configure(api_key=GEMINI_API_KEY)

def get_movies_from_description_using_gemini(description, exclude_list):
    
    
    try:
        model = genai.GenerativeModel("gemini-1.5-flash")  # Using a valid model
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

        
        response = model.generate_content(prompt)

        # Extracting text response
        response_text = response.text.strip()

        # Remove Markdown-style code blocks (```json ... ```)
        if response_text.startswith("```json"):
            response_text = response_text.replace("```json", "").replace("```", "").strip()

        # Convert response to a Python list
        try:
            movies = json.loads(response_text)  # Parse as JSON
            if isinstance(movies, list):  
                return movies
            else:
                raise ValueError("Gemini response is not a list")
        except json.JSONDecodeError:
            return {"error": "Failed to parse JSON from Gemini response", "response": response_text}

    except Exception as e:
        return {"error": str(e)}  # Return error message

def generate_itinerary_using_gemini(destination, duration, interests, budget, exclude):
    try:
        model = genai.GenerativeModel("gemini-1.5-flash")
        prompt = f"""
        Create a detailed {duration}-day travel itinerary for {destination} focusing on {interests}.
        Budget level: {budget or 'medium'}.
        Include for each day:
        - Morning activity
        - Afternoon activity
        - Evening activity
        - Recommended accommodations
        - Local transportation tips
        
        Format as JSON array with keys:
        "day", "date", "activities", "accommodation", "transportation"
        
        Exclude: {exclude}
        """
        
        # Print the generated prompt
        print(f"\n=== Gemini Prompt ===\n{prompt}\n====================\n")
        
        response = model.generate_content(prompt)
        response_text = response.text.strip()
        
        if response_text.startswith("```json"):
            response_text = response_text.replace("```json", "").replace("```", "").strip()
            
        itinerary = json.loads(response_text)
        if isinstance(itinerary, list):
            return itinerary
        return {"error": "Invalid itinerary format"}

    except Exception as e:
        return {"error": str(e)}