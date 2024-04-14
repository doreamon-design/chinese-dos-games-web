FROM whatwewant/python:v3.10-1

RUN apk --no-cache add git  \
        && pip3 install --upgrade pip  \
        && pip3 install gunicorn flask

WORKDIR /app

RUN GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone https://github.com/rwv/chinese-dos-games.git /app/games-tools

RUN python3 /app/games-tools/download_data.py

COPY . .

# RUN git submodule update --init --recursive --remote 

# RUN python3 ./static/games/download_data.py

RUN rm -rf /app/static/games && mv /app/games-tools /app/static/games

EXPOSE 5000

# CMD python3 app.py

CMD gunicorn -w 5 -b 0.0.0.0:5000 app:app
