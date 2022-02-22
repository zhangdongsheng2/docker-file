FROM openjdk:8u322

ENV KE_HOME=/opt/kafka-eagle
ENV EAGLE_VERSION=2.1.0

COPY entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh

CMD ["sh", "/opt/entrypoint.sh"]
