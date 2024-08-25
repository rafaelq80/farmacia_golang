# syntax=docker/dockerfile:1


##

## STEP 1 - BUILD

##


# specify the base image to  be used for the application, alpine or ubuntu

FROM golang:1.23.0-alpine AS build

RUN go get github.com/swaggo/swag/cmd/swag

RUN go get -u github.com/swaggo/fiber-swagger

# create a working directory inside the image

WORKDIR /app


# copy Go modules and dependencies to image

COPY go.mod .
COPY go.sum .

# Instalar as Bibliotecas Externas (Adicionar todas elas)
# Testar sem a próxima linha

# RUN go get github.com/gorilla/mux

# download Go modules and dependencies

RUN go mod download


# copy directory files i.e all files ending with .go

COPY . . 

RUN swag init

# compile application

RUN go build -o /farmacia_go


##

## STEP 2 - DEPLOY

##

FROM alpine:latest

WORKDIR /


COPY --from=build /farmacia_go .


EXPOSE 8000


ENTRYPOINT ["/farmacia_go"]