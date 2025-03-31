# sonorus

## About
Repository for undergraduate work. The work is about creating a social network for musicians and music fans using Flutter, .NET and Azure services.

## Technologies and components:
- ### Core Technologies:
    - .NET 9 with and ASP.NET CORE;
    - SQL Server with EntityFramework Core ORM;
    - Using JWT Authentication, MediatR, IMemoryCache, FluentValidation and AutoMapper;

- ### Architectural Patterns & Design
    - Microservices Architecture (5 WEB API's and 4 databases);
    - Domain-Driven Design (DDD);
    - Event-Driven Architecture (EDA);
    - Unit of Work;
    - CQRS Pattern;
    - Repository Pattern;
    - Proxy Pattern (e.g. caching interests before accessing the repository);

- ### Microservices & Infrastructure
    - Docker & Docker Compose;
    - Ocelot Gateway.
  
- ### Real-Time & Communication
    - SignalR with Authentication.

- ### Cloud Services
    - Using cloud services like Azure Service Bus, Azure Blob Storage and Azure CosmosDb.

- ### Frontend Mobile
    - Flutter with Flutter Modular and Mobx.
 
## Architecture Overview
  - ### Source
    <img width="64%" src="https://github.com/user-attachments/assets/818c763c-3743-4d31-ab2c-c526db6571ee"/>
    <img width="35%" src="https://github.com/user-attachments/assets/8c6d6f7d-6cd3-4fb9-ac99-6a57a2d8d6ac"/>

  - ### Conceptual Architecture
    <img src="https://github.com/user-attachments/assets/5f237660-e155-4e6c-b007-a8b2f52946b3"/>

## Demo
Images of the main parts of the software

- Login:
  <br>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/9ad76f37-e048-4948-8c28-51b46762edcc"></img>

- Registration, definition of interests and photo:
  <br>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/503c44ad-1386-4153-b22b-037a66a644b7"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/40e2a34c-3f46-4f1a-b82f-a14d477427fa"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/9d461eeb-e9b3-4e54-a57f-21f09f40e43c"></img>

- Profile:
  <br>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/54e9f2a0-96df-48cb-809c-ff6e56114816"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/82653c26-8f89-4e26-a350-614a3cdf1748"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/06614a36-9389-43b4-8269-3c5e04035d08"></img>

- Posts:
  <br>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/448617cb-2092-421c-972e-8e1dc8626205"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/32d7ae86-8a1f-4a08-bffe-b263f0fae712"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/2b2cc23a-de7c-4495-b53d-0e0836c16c0f"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/8cc10fe2-0821-4c01-a404-8d1ce6030968"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/232ccf5e-9a90-4354-9589-9335d36b347b"></img>
  <video width="30%" heigth="30%" src="https://github.com/user-attachments/assets/7055e37e-d42d-4dab-9c30-b152f0938392"></video>

- Products:
  <br>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/a778d848-f190-4f0c-bc4a-474a02751396"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/42565166-b78c-4ce5-a40a-aa8d78b70107"></img>

- Opportunities:
  <br>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/bfd16d86-ed39-4947-92cf-c4f6a2c09587"></img>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/aff06936-bc3f-4997-8b87-4bd7466c3064"></img>

- Real-time chat:
  <br>
  <img width="30%" heigth="30%" src="https://github.com/user-attachments/assets/a23740de-1040-40ea-9ebc-9a863f0d4484"></img>
  <video width="30%" heigth="30%" src="https://github.com/user-attachments/assets/abb8d1fd-08ea-4db5-9370-e457482712dc"></video>

## Running
  - ### Microsservices
    To run the microservices, ensure that:
    - That you have Docker installed on your machine (if not, you can run project by project and configure the API Gateway manually, as the Docker version is already configured);
    - Configure all information such as connection strings, etc. of cloud services in the `appsettings.json` of the WEB API's.

  - ### Flutter App
    To run the android app, ensure that:
    - The API Gateway address in the `src/app/.env` file points to the current one running on your machine;
    - Have the flutter SDK installed on your machine.

## Contribute
Feel free to contribute to the project by opening a pull request with new ideas or even improvements and corrections in this branch.
