# Etapa de build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia el archivo .csproj y restaura dependencias
COPY InvitacionBirthdayAPI/InvitacionBirthdayAPI.csproj ./InvitacionBirthdayAPI/
RUN dotnet restore ./InvitacionBirthdayAPI/InvitacionBirthdayAPI.csproj

# Copia el resto del contenido y publica la aplicación
COPY . .
RUN dotnet publish ./InvitacionBirthdayAPI/InvitacionBirthdayAPI.csproj -c Release -o /app/out

# Etapa de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copia los archivos publicados
COPY --from=build /app/out .

# Configurar el puerto
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

# Comando de inicio
ENTRYPOINT ["dotnet", "InvitacionBirthdayAPI.dll"]
