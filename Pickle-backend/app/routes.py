from flask import Blueprint, jsonify, request
from app.gemini.utils import *
from app.deepseek.utils import *
from app.openperplex.utils import *
from app.perplexity.utils import *




main = Blueprint('main', __name__)

@main.route('/')
def home():
    return jsonify({"message": "Welcome to your decision-making API!"})

    

@main.route('/api/searchMovieBasedOnDescriptionWithGemini', methods=['POST'])
def searchMovieBasedOnDescriptionWithGemini():
    data = request.json
    user_query = data.get('query', '')
    exclude_list = data.get('exclude', '')


    if not user_query:
        return jsonify({"error": "No query provided"}), 400

    try:
        movies = get_movies_from_description_using_gemini(user_query, exclude_list)
        
        # Ensure we return a JSON list
        if isinstance(movies, list):
            return jsonify({"movies": movies}), 200  # Explicitly return 200 for clarity
        else:
            return jsonify({"error": movies}), 500  # Return 500 only for errors

    
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    

@main.route('/api/searchMovieBasedOnDescriptionWithDeepSeek', methods=['POST'])
def searchMovieBasedOnDescriptionWithDeepSeek():
    data = request.json
    user_query = data.get('query', '')
    exclude_list = data.get('exclude', '')


    if not user_query:
        return jsonify({"error": "No query provided"}), 400

    try:
        movies = get_movies_from_description_using_deepseek(user_query,exclude_list)
        
        # Ensure we return a JSON list
        if isinstance(movies, list):
            return jsonify({"movies": movies}), 200  # Explicitly return 200 for clarity
        else:
            return jsonify({"error": movies}), 500  # Return 500 only for errors
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    



# @main.route('/api/searchShowBasedOnDescriptionWithGemini', methods=['POST'])
# def searchShowBasedOnDescriptionWithGemini():
#     data = request.json
#     user_query = data.get('query', '')
#     exclude_list = data.get('exclude', '')


#     if not user_query:
#         return jsonify({"error": "No query provided"}), 400

#     try:
#         shows = get_shows_from_description_using_gemini(user_query, exclude_list)
        
#         # Ensure we return a JSON list
#         if isinstance(shows, list):
#             return jsonify({"shows": shows}), 200  # Explicitly return 200 for clarity
#         else:
#             return jsonify({"error": movies}), 500  # Return 500 only for errors

    
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
    

# @main.route('/api/searchShowBasedOnDescriptionWithDeepSeek', methods=['POST'])
# def searchShowBasedOnDescriptionWithDeepSeek():
#     data = request.json
#     user_query = data.get('query', '')
#     exclude_list = data.get('exclude', '')


#     if not user_query:
#         return jsonify({"error": "No query provided"}), 400

#     try:
#         shows = get_movies_from_description_using_deepseek(user_query, exclude_list)
        
#         # Ensure we return a JSON list
#         if isinstance(shows, list):
#             return jsonify({"shows": shows}), 200  # Explicitly return 200 for clarity
#         else:
#             return jsonify({"error": shows}), 500  # Return 500 only for errors
    
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
    
    
    
    
    
# @main.route('/api/searchAnimeBasedOnDescriptionWithGemini', methods=['POST'])
# def searchAnimeBasedOnDescriptionWithGemini():
#     data = request.json
#     user_query = data.get('query', '')
#     exclude_list = data.get('exclude', '')


#     if not user_query:
#         return jsonify({"error": "No query provided"}), 400

#     try:
#         animes = get_animes_from_description_using_gemini(user_query, exclude_list)
        
#         # Ensure we return a JSON list
#         if isinstance(animes, list):
#             return jsonify({"animes": animes}), 200  # Explicitly return 200 for clarity
#         else:
#             return jsonify({"error": animes}), 500  # Return 500 only for errors

    
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
    

# @main.route('/api/searchAnimeBasedOnDescriptionWithDeepSeek', methods=['POST'])
# def searchAnimeBasedOnDescriptionWithDeepSeek():
#     data = request.json
#     user_query = data.get('query', '')
#     exclude_list = data.get('exclude', '')


#     if not user_query:
#         return jsonify({"error": "No query provided"}), 400

#     try:
#         animes = get_animes_from_description_using_deepseek(user_query, exclude_list)
        
#         # Ensure we return a JSON list
#         if isinstance(animes, list):
#             return jsonify({"animes": animes}), 200  # Explicitly return 200 for clarity
#         else:
#             return jsonify({"error": animes}), 500  # Return 500 only for errors
    
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
    
    
    
    
    
# @main.route('/api/searchBookBasedOnDescriptionWithGemini', methods=['POST'])
# def searchBookBasedOnDescriptionWithGemini():
#     data = request.json
#     user_query = data.get('query', '')
#     exclude_list = data.get('exclude', '')


#     if not user_query:
#         return jsonify({"error": "No query provided"}), 400

#     try:
#         books = get_books_from_description_using_gemini(user_query, exclude_list)
        
#         # Ensure we return a JSON list
#         if isinstance(books, list):
#             return jsonify({"books": books}), 200  # Explicitly return 200 for clarity
#         else:
#             return jsonify({"error": books}), 500  # Return 500 only for errors

    
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
    

# @main.route('/api/searchBookBasedOnDescriptionWithDeepSeek', methods=['POST'])
# def searchBookBasedOnDescriptionWithDeepSeek():
#     data = request.json
#     user_query = data.get('query', '')
#     exclude_list = data.get('exclude', '')


#     if not user_query:
#         return jsonify({"error": "No query provided"}), 400

#     try:
#         books = get_books_from_description_using_deepseek(user_query, exclude_list)
        
#         # Ensure we return a JSON list
#         if isinstance(books, list):
#             return jsonify({"books": books}), 200  # Explicitly return 200 for clarity
#         else:
#             return jsonify({"error": books}), 500  # Return 500 only for errors
    
#     except Exception as e:
#         return jsonify({"error": str(e)}), 500
    


@main.route('/api/searchCurrentMoviesInCinemasUsingOpenPerplex', methods=['POST'])
def searchCurrentMoviesInCinemasUsingOpenPerplex():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid or missing JSON payload"}), 400

    pincode = data.get('pincode', '')
    date = data.get('date', '')
    radius = data.get('radius', 10)  # Default to 10 miles if not provided

    if not pincode or not date:
        return jsonify({"error": "Pincode and date are required"}), 400

    try:
        movies_data = get_current_movies_in_cinemas_using_openperplex(pincode, date, radius)

        # Ensure movies_data is a dictionary
        if not isinstance(movies_data, dict):
            return jsonify({"error": "Invalid response format from OpenPerplex"}), 500

        # Check if no movies were found
        if movies_data.get("cinemas") == {}:
            return jsonify({"message": "No movies found for the given date and location"}), 200

        return jsonify(movies_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@main.route('/api/searchCurrentMoviesInCinemasUsingPerplexity', methods=['POST'])
def search_current_movies_in_cinemas_using_perplexity():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid or missing JSON payload"}), 400

    pincode = data.get('pincode', '')
    date = data.get('date', '')
    radius = data.get('radius', 10)  # Default to 10 miles if not provided

    if not pincode or not date:
        return jsonify({"error": "Pincode and date are required"}), 400

    try:
        movies_data = get_current_movies_in_cinemas_using_perplexity(pincode, date, radius)

        # Ensure movies_data is a dictionary
        if not isinstance(movies_data, dict) or movies_data.get("cinemas") == {}:
            return jsonify({"message": "No movies found for the given date and location"}), 200

        return jsonify(movies_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
		
@main.route('/api/generateTravelItineraryWithGemini', methods=['POST'])
def generate_travel_itinerary_gemini():
    data = request.json
    destination = data.get('destination')
    duration = data.get('duration')
    interests = data.get('interests')
    budget = data.get('budget')
    exclude = data.get('exclude', '')

    if not all([destination, duration, interests]):
        return jsonify({"error": "Missing required parameters"}), 400

    try:
        itinerary = generate_itinerary_using_gemini(
            destination=destination,
            duration=duration,
            interests=interests,
            budget=budget,
            exclude=exclude
        )
        return jsonify({"itinerary": itinerary}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@main.route('/api/generateTravelItineraryWithDeepSeek', methods=['POST'])
def generate_travel_itinerary_deepseek():
    data = request.json
    destination = data.get('destination')
    duration = data.get('duration')
    interests = data.get('interests')
    budget = data.get('budget')
    exclude = data.get('exclude', '')

    if not all([destination, duration, interests]):
        return jsonify({"error": "Missing required parameters"}), 400

    try:
        itinerary = generate_itinerary_using_deepseek(
            destination=destination,
            duration=duration,
            interests=interests,
            budget=budget,
            exclude=exclude
        )
        if isinstance(itinerary, dict) and 'error' in itinerary:
            return jsonify(itinerary), 500
        return jsonify({"itinerary": itinerary}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    
    
    
@main.route('/api/createScheduleUsingDeepseek', methods=['POST'])
def create_schedule():
    # Get the request data
    data = request.get_json()
    calendar_events = data.get("calendarEvents", [])
    tasks = data.get("tasks", [])
    physical_activities = data.get("physicalActivities", [])

    # Validate the input data
    if not isinstance(calendar_events, list) or not isinstance(tasks, list) or not isinstance(physical_activities, list):
        return jsonify({"error": "Invalid input format. Expected lists for calendarEvents, tasks, and physicalActivities."}), 400

    # Call the DeepSeek function to generate the schedule
    schedule = create_schedule_using_deepseek(calendar_events, tasks, physical_activities)

    # Check for errors in the response
    if "error" in schedule:
        return schedule, 500

    # Return the generated schedule
    return schedule, 200


@main.route('/api/suggestHomeMealsUsingDeepSeek', methods=['POST'])
def suggest_home_meals_deepseek():
    data = request.json
    required_params = ['ingredients']
    
    if not all(key in data for key in required_params):
        return jsonify({"error": "Missing required parameters (ingredients)"}), 400

    try:
        recommendations = get_meal_suggestions_using_deepseek(
            ingredients=data['ingredients'],
            preferences=data.get('preferences', ''),
            calorie=data.get('calorie'),
            protein=data.get('protein')
        )
        
        if isinstance(recommendations, dict) and 'error' in recommendations:
            return jsonify(recommendations), 500
            
        return jsonify(recommendations), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@main.route('/api/findGroceryStoresUsingPerplexity', methods=['POST'])
def find_grocery_stores_perplexity():
    data = request.json
    if not data.get('missing_items') or not data.get('zipcode'):
        return jsonify({"error": "Missing required parameters (missing_items, zipcode)"}), 400

    try:
        stores = find_grocery_stores_using_perplexity(
            missing_items=data['missing_items'],
            zipcode=data['zipcode'],
            radius=data.get('radius', 3)
        )
        
        return jsonify({"stores": stores}) if stores else jsonify({"message": "No stores found"}), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@main.route('/api/findRestaurantsUsingPerplexity', methods=['POST'])
def find_restaurants_perplexity():
    data = request.json
    if not data.get('zipcode') or not data.get('cuisine_or_dish_preferred'):
        return jsonify({"error": "Missing required parameters (zipcode, cuisine_or_dish_preferred)"}), 400

    try:
        restaurants = find_restaurants_using_perplexity(
            zipcode=data['zipcode'],
            cuisine_or_dish=data['cuisine_or_dish_preferred'],
            allergies=data.get('allergies', ''),
            radius=data.get('radius', 2)
        )
        
        return jsonify({"restaurants": restaurants}) if restaurants else jsonify({"message": "No restaurants found"}), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500