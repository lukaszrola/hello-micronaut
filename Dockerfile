FROM oracle/graalvm-ce:20.1.0-java11 as graalvm
RUN gu install native-image

COPY . /home/app/hello-graal
WORKDIR /home/app/hello-graal

RUN native-image --no-server -cp build/libs/hello-graal-*-all.jar

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/hello-graal/hello-graal /app/hello-graal
ENTRYPOINT ["/app/hello-graal"]
