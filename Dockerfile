# ---------- Стадия сборки ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# копируем всё в контейнер
COPY . .

# собираем и публикуем релизную версию
RUN dotnet publish -c Release -o /app/publish

# ---------- Стадия рантайма ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Cloud Run по умолчанию работает с портом 8080
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080

# копируем опубликованное приложение из предыдущей стадии
COPY --from=build /app/publish .

# ВАЖНО: сюда впиши имя твоей dll (оно совпадает с именем проекта)
ENTRYPOINT ["dotnet", "CloudTechLab5.dll"]
