FROM --platform=linux/arm64 public.ecr.aws/docker/library/node:20.9.0-slim as runner
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.3 /lambda-adapter /opt/extensions/lambda-adapter
ENV PORT=3000 NODE_ENV=production
ENV AWS_LWA_ENABLE_COMPRESSION=true
WORKDIR /app
COPY ./package.json ./package.json
COPY ./package-lock.json ./package-lock.json
COPY ./build/server ./build/server
COPY ./run.sh ./run.sh
RUN npm ci --omit=dev
RUN chmod +x ./run.sh

CMD exec ./run.sh