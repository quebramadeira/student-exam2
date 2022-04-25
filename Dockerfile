FROM python:3.8-alpine
RUN apk update && apk add git \
&& git config --global user.name "quebramadeira" \
&& git config --global user.email quantumrods@gmail.com\
&& git clone https://github.com/quebramadeira/student-exam2 /exam2
WORKDIR /exam2
EXPOSE 5000
CMD python3 -m venv venv \
    && . venv/bin/activate \
    && pip install -e . \
    && export FLASK_APP=js_example \
    && flask run --host 0.0.0.0
