from dotenv import load_dotenv
import os
from groq import Groq

load_dotenv()

client = Groq(
    api_key=os.getenv("GROQ_API_KEY")
)

print("Enviando áudio para Whisper...")

with open("trecho.mp3", "rb") as file:

    resposta = client.audio.transcriptions.create(
        file=file,
        model="whisper-large-v3",
        response_format="text"
    )

print("\n==============================")
print("TRANSCRIÇÃO")
print("==============================\n")

print(resposta)