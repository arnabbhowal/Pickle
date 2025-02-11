import os
from dotenv import load_dotenv

# Load .env variables once
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")


GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY")

OPENPERPLEX_API_KEY = os.getenv("OPENPERPLEX_API_KEY")

PERPLEXITY_API_KEY = os.getenv("PERPLEXITY_API_KEY")