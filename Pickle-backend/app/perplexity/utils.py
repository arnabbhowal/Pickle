from openai import OpenAI
from typing import Dict
import json
import os
import re


# Load API key from environment variable
PERPLEXITY_API_KEY = os.getenv("PERPLEXITY_API_KEY")


def get_current_movies_in_cinemas_using_perplexity(pincode: str, date: str, radius: int) -> Dict:
    """
    Calls the Perplexity API to fetch movies currently playing in cinemas for the given pincode, date, and radius.
    Ensures a structured JSON response. If no movies are found, it returns {"cinemas": {}}.
    """
    if not PERPLEXITY_API_KEY:
        return {"error": "Missing API key"}

    # Initialize the Perplexity API client
    client = OpenAI(api_key=PERPLEXITY_API_KEY, base_url="https://api.perplexity.ai")

    # Define the prompt for the Perplexity API
    prompt = (
        f"Find movies currently playing in cinema halls on {date}, within a {radius}-mile radius of the area with pincode {pincode}. "
        "If no showtimes are available for the given date, return an empty JSON object: {'cinemas': {}}. "
        "Otherwise, structure the response with cinema halls as the primary key, listing movies, their show timings, and a source link. "
        "The JSON response should follow this exact structure: "
        '{"cinemas": {"Cinema Name": {"movies": [{"movie_name": "Movie Name", "show_timings": ["time1", "time2"], "source": "source_url"}]}}}'
    )

    try:
        # Call the Perplexity API
        response = client.chat.completions.create(
            model="sonar",
            messages=[
                {"role": "system", "content": "You are an AI that fetches real-time movie listings in cinemas."},
                {"role": "user", "content": prompt},
            ],
            stream=False,
        )

        # Extract the response content
        response_text = response.choices[0].message.content.strip()

        # Use regex to extract the JSON string from the response
        json_match = re.search(r"```json\n(.+?)\n```", response_text, re.DOTALL)
        if json_match:
            json_string = json_match.group(1).strip()
        else:
            # If no JSON block is found, assume the entire response is JSON
            json_string = response_text

        # Parse the JSON string
        try:
            movies_data = json.loads(json_string)
            return movies_data
        except json.JSONDecodeError as e:
            return {"error": f"Failed to parse JSON response: {str(e)}", "response": response_text}

    except Exception as e:
        return {"error": f"Perplexity API request failed: {str(e)}"}


def find_grocery_stores_using_perplexity(missing_items: list, zipcode: str, radius: int = 3):
    try:
        client = OpenAI(api_key=PERPLEXITY_API_KEY, base_url="https://api.perplexity.ai")
        
        prompt = f"""
        Find grocery stores within {radius} miles of {zipcode} that sell these items: {', '.join(missing_items)}.
        Return results as a JSON array with:
        - store_name
        - address
        - items_sold (specific items from the request list that are available)
        
        For each store, include:
        - Actual items from the requested list that are available
        - Focus on stores with fresh produce and whole foods
        
        Example format:
        {{
            "store_name": "Whole Foods Market",
            "address": "123 Main St, City, ST 12345",
            "items_sold": ["organic basil", "extra virgin olive oil"]
        }}
        """

        response = client.chat.completions.create(
            model="sonar",
            messages=[
                {"role": "system", "content": "You are a food sourcing expert focused on fresh ingredients."},
                {"role": "user", "content": prompt}
            ]
        )
        
        response_text = response.choices[0].message.content.strip()
        json_match = re.search(r"```json\n(.+?)\n```", response_text, re.DOTALL)
        json_string = json_match.group(1).strip() if json_match else response_text
        
        try:
            stores = json.loads(json_string)
            return stores if isinstance(stores, list) else []
        except json.JSONDecodeError:
            return {"error": "Failed to parse store data", "response": response_text}

    except Exception as e:
        return {"error": str(e)}


def find_restaurants_using_perplexity(zipcode: str, cuisine_or_dish: str, allergies: str = "", radius: int = 2):
    try:
        client = OpenAI(api_key=PERPLEXITY_API_KEY, base_url="https://api.perplexity.ai")
        
        prompt = f"""
        Find restaurants within {radius} miles of {zipcode} that serve {cuisine_or_dish} or have it on their menu.
        {f"Avoid ingredients: {allergies}" if allergies else ""}
        
        Return results as a JSON array with:
        - restaurant_name
        - address
        - rating (out of 5)
        - price_range (actual numerical range from menu data e.g., "$10-25")
        - favorites (combination of 3 popular dishes and customer praises)
        
        Example format for "Burger" search:
        {{
            "restaurant_name": "The Burger Joint",
            "address": "123 Beef St, Brooklyn, NY 11201",
            "rating": 4.6,
            "price_range": "$12-18",
            "favorites": [
                "Classic Cheeseburger (Juicy patty with melted cheddar - $14)",
                "Truffle Fries (Crispy with real truffle oil - $8)",
                "Milkshakes (Thick and creamy - customers love the vanilla bean)"
            ]
        }}
        
        Example format for "Sushi" search:
        {{
            "restaurant_name": "Sushi Master",
            "address": "456 Fish Ave, Brooklyn, NY 11201",
            "rating": 4.8,
            "price_range": "$25-50",
            "favorites": [
                "Omakase Platter (Chef's selection - $45-75)",
                "Spicy Tuna Roll (Perfect heat balance - $18)",
                "Fresh Uni (Daily imported - reviewers call it 'melt-in-mouth')"
            ]
        }}
        """

        response = client.chat.completions.create(
            model="sonar",
            messages=[
                {"role": "system", "content": "You are a food critic and restaurant analyst."},
                {"role": "user", "content": prompt}
            ]
        )
        
        response_text = response.choices[0].message.content.strip()
        json_match = re.search(r"```json\n(.+?)\n```", response_text, re.DOTALL)
        json_string = json_match.group(1).strip() if json_match else response_text
        
        try:
            restaurants = json.loads(json_string)
            return restaurants if isinstance(restaurants, list) else []
        except json.JSONDecodeError:
            return {"error": "Failed to parse restaurant data", "response": response_text}

    except Exception as e:
        return {"error": str(e)}
