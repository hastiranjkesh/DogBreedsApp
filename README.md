# DogBreedsApp

This Xcode project is a Swift application that uses the MVVM architecture pattern, UIKit and the Combine framework. 
It is designed to provide a simple example of how to structure an iOS application using MVVM and how to utilize the Combine framework 
to manage asynchronous data flows.

# Architecture

The project uses the MVVM (Model-View-ViewModel) architecture pattern. This pattern separates the presentation logic (ViewModel) from the business logic (Model) and 
the user interface (View). The ViewModel communicates with the Model to get the data, processes it, and sends it back to the View to be displayed.

The project also uses the Combine framework, which is a reactive programming framework that allows for declarative programming of asynchronous operations.
This allows for a more concise and readable code, as well as easier management of data flows.

The code is organized into several folders:

- Model: Contains the business logic and data models.
- ViewModel: Contains the presentation logic and manages the data flow between the View and the Model.
- View: Contains the user interface code.

The ViewModel communicates with the Model to get the data, processes it, and sends it back to the View to be displayed. 
The View displays the data and sends user actions back to the ViewModel.
The ViewModel also uses Combine to manage asynchronous data flows. It uses publishers to get data from the Model and to send data back to the View.

# Requirements

- Xcode 12 or higher
- iOS 14.0 or higher

# Installation

- Clone or download the repository.
- Open the project in Xcode.
- Build and run the project.

# Credits

This project was created by me :) If you have any questions or suggestions, please contact me at hasti.ranjkesh@gmail.com.
