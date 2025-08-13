import os
import sys
from dotenv import load_dotenv
from google import genai
from google.genai import types

messages = [
    types.Content(role="user", parts=[types.Part(text=sys.argv[1])]),
]

load_dotenv()
api_key = os.environ.get("GEMINI_API_KEY")
client = genai.Client(api_key=api_key)

response = client.models.generate_content(
    model='gemini-2.0-flash-001', contents=messages
)
print(response.text)