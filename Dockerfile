# Usa uma imagem base Python leve. Alpine é uma boa escolha para imagens menores.
FROM python:3.13.5-alpine3.22

# Define variáveis de ambiente para o Python.
# PYTHONUNBUFFERED garante que o log do Python seja exibido em tempo real no console.
# PYTHONDONTWRITEBYTECODE evita a criação de arquivos .pyc, que não são necessários na imagem final.
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Define o diretório de trabalho dentro do contêiner.
WORKDIR /app

# Copia o arquivo de dependências (requirements.txt) primeiro.
# Isso permite que o Docker use o cache da camada se as dependências não mudarem,
# acelerando builds subsequentes.
COPY requirements.txt .

# Instala as dependências Python.
# --no-cache-dir evita que o pip armazene em cache os pacotes baixados, reduzindo o tamanho da imagem.
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo o restante do código da sua aplicação para o contêiner.
COPY . .

# Expõe a porta que sua aplicação FastAPI vai escutar.
# A porta padrão do Uvicorn (servidor que o FastAPI usa) é 8000.
EXPOSE 8000

# Comando para iniciar sua aplicação usando Uvicorn.
# A flag --host 0.0.0.0 é crucial para que a aplicação seja acessível de fora do contêiner.
# main:app indica que seu objeto FastAPI 'app' está no arquivo 'main.py'.
# Se o seu arquivo principal tiver outro nome (ex: app.py), ajuste para 'nome_do_arquivo:app'.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
