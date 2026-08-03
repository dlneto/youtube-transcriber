import os
import subprocess
import datetime
from pathlib import Path

from dotenv import load_dotenv
from groq import Groq


# =========================
# Configuração
# =========================

load_dotenv()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
GROQ_MODEL = os.getenv(
    "GROQ_MODEL",
    "whisper-large-v3"
)

if not GROQ_API_KEY:
    raise Exception(
        "GROQ_API_KEY não encontrada no .env"
    )


client = Groq(
    api_key=GROQ_API_KEY
)


BASE_DIR = Path(__file__).parent

TEMP_DIR = BASE_DIR / "temp"
OUTPUT_DIR = BASE_DIR / "transcripts"


TEMP_DIR.mkdir(exist_ok=True)
OUTPUT_DIR.mkdir(exist_ok=True)


# =========================
# Funções
# =========================


def normalizar_tempo(t):
    """
    Aceita:
    48:51
    1:16:30

    Converte para:
    HH:MM:SS
    """

    partes = t.split(":")

    if len(partes) == 2:
        return "00:" + t

    return t



def baixar_audio(url):

    arquivo = TEMP_DIR / "live_audio.m4a"

    print("\n⬇ Baixando áudio da live...")

    comando = [
        "yt-dlp",
        "-f",
        "140",
        "-o",
        str(arquivo),
        url
    ]

    subprocess.run(
        comando,
        check=True
    )

    return arquivo



def cortar_audio(
        entrada,
        inicio,
        fim
):

    saida = TEMP_DIR / "trecho.mp3"

    print("\n✂ Cortando trecho...")


    comando = [
        "ffmpeg",
        "-y",
        "-ss",
        inicio,
        "-to",
        fim,
        "-i",
        str(entrada),
        "-vn",
        "-ar",
        "16000",
        "-ac",
        "1",
        "-b:a",
        "64k",
        str(saida)
    ]


    subprocess.run(
        comando,
        check=True
    )


    return saida



def transcrever(audio):

    print("\n🎤 Enviando para Whisper...")


    with open(
        audio,
        "rb"
    ) as arquivo:


        resultado = client.audio.transcriptions.create(
            file=arquivo,
            model=GROQ_MODEL,
            response_format="text"
        )


    return resultado



def salvar(texto):

    nome = datetime.datetime.now().strftime(
        "transcricao_%Y-%m-%d_%H-%M.txt"
    )

    arquivo = OUTPUT_DIR / nome


    with open(
        arquivo,
        "w",
        encoding="utf-8"
    ) as f:

        f.write(texto)


    return arquivo



def limpar():

    for arquivo in TEMP_DIR.iterdir():

        try:
            arquivo.unlink()

        except:
            pass



# =========================
# Programa principal
# =========================


def main():

    print("="*50)
    print(" YAH TRANSCRIBER - PARTE 1")
    print("="*50)


    url = input(
        "\nLink do YouTube: "
    )


    inicio = input(
        "Tempo inicial (ex: 48:51): "
    )


    fim = input(
        "Tempo final (ex: 1:16:30): "
    )


    inicio = normalizar_tempo(inicio)
    fim = normalizar_tempo(fim)


    try:

        audio = baixar_audio(url)


        trecho = cortar_audio(
            audio,
            inicio,
            fim
        )


        texto = transcrever(
            trecho
        )


        arquivo = salvar(
            texto
        )


        limpar()


        print("\n==============================")
        print("✔ CONCLUÍDO")
        print("==============================")

        print(
            f"\nTranscrição salva em:\n{arquivo}"
        )


    except Exception as erro:

        print("\nERRO:")
        print(erro)



if __name__ == "__main__":
    main()