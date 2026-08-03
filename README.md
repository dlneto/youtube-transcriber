\# YAH Transcriber



Aplicação em Python para baixar um trecho de áudio de uma live ou vídeo do YouTube e gerar sua transcrição.



O programa solicita:



\- Link do vídeo ou live do YouTube;

\- Tempo inicial do trecho;

\- Tempo final do trecho.



Em seguida, baixa o áudio, recorta o período informado e realiza a transcrição.



\---



\## Funcionalidades



\- Download de áudio de vídeos e lives do YouTube;

\- Seleção de intervalo por tempo inicial e final;

\- Transcrição de áudio usando a API da Groq;

\- Organização de arquivos temporários na pasta `temp`;

\- Salvamento das transcrições na pasta `transcripts`.



\---



\## Tecnologias utilizadas



\- \[Python](https://www.python.org/)

\- \[yt-dlp](https://github.com/yt-dlp/yt-dlp)

\- API da \[Groq](https://console.groq.com/)

\- FFmpeg



\---



\## Estrutura do projeto



```text

youtube\_transcriber/

├── .env                  # Variáveis de ambiente e chave da API (não enviar ao GitHub)

├── .gitignore

├── README.md

├── requirements.txt      # Dependências Python

├── transcriber.py        # Programa principal

├── teste\_groq.py         # Teste de conexão/transcrição com a Groq

├── temp/                 # Arquivos temporários de áudio

└── transcripts/          # Transcrições geradas



