FROM maven as build

RUN addgroup -S robo && adduser -S robo robo

WORKDIR /opt/shipping

USER robo

COPY pom.xml .
RUN mvn dependenxy:resolve

COPY src .

RUN mvn package

############# STAGE-2 ################

FROM openjdk

RUN addgroup -S robo && adduser -S robo robo

WORKDIR /opt/shipping

USER robo

ENV CART_ENDPOINT=cart:8080 \
    DB_HOST=mysql

COPY --from=build /opt/shipping/target/shipping-1.0.jar .

ENTRYPOINT [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]
