# Architecture 

![The Clean Architecture](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)

This project demonstrates a simple application using a combination of clean architecture + MVVM.  One of the goals will be to establish a separation of concerns (SRP).  Another goal will be to enforce the decoupling of the UI from the data layer and business logic.  This serves several purposes: 
1. It decouples the core logic (models and use cases) from the presentation layer which can be quite volatile and prone to frequent changes.  
2. By having the UI separate from the core logic, the core logic is able to be tested without involving the UI.  This makes for safer better business logic, but also engineers may be more eager to include tests which are simpler to execute requiring less time and complexity.  
3. By separating the inner core logic from the UI and presentation layer, the application becomes more flexible and maintainable.  The code can be updated independent from the UI/ Presentation layer.  This will pay dividends throughout the lifespan of the application. 
4. The core logic can be reused for different business flows. 
5. Inversion of Control. The dependency inversion principal indicates that high level modules (Presentation layer) should not depend on low level modules but instead depend on abstractions (interfaces/ protocols).  This decoupling system provides a system that is easier to modify and extend.  

### The flow for this application in summary: 

Coordinator 
-> Makes Dependency Container for Business flow 
-> Dependency Container creates via factory pattern the Use Case(s), Presentation Layer (VM and VC), and collects all dependencies needed. 
-> Coordinator starts flow of DependencyContainer via .start() function 
->  Use Case is injected with Dependencies 
-> View Models are injected with Use Case 
-> View Controller with injected ViewModel
-> View Controller is loaded onto the view.  


### Container
The flow begins with a container object.  The purpose of this container is to capture the dependencies needed for the particular flow as well as collecting the use cases that will apply to this particular logic flow.. in this project, the containers: 
	1. collect dependencies and inject those into the view model 
	2. instantiate the view model 
	3. instantiate the view controller 
	4. instantiate a use case object (by protocol)
	5. instantiate a coordinator 

### Coordinator
Coordinators are akin to Routers and drive the presentation layer.  Typically the flow for a coordinator in this architecture is: 
1. Coordinator make a container (laying out dependencies, use cases, and presentation layer)
2. Coordinator uses the new container's coordinator to start that flow using the `flow.start()`
function.  
3. Typically start function kicks off a presentation layer UI driven path.  

### Use Cases
Use cases are this architectures space to handle business logic.. these are analogous to placing business logic within the ViewModel or within the Controller of MVC.  The business logic is not tied to specific entities or dependencies or UI.   Examples of possible use cases in mobile architecture: 

* Authenticate user 
* Sync Data
* Add New Task 
* Load User Profile 
* Place Order
* Fetch Articles
* Send Notification

Or in the case of this project: 
* Fetch Beneficiaries from local JSON file

### Presentation - UI
This project uses a MVVM design pattern to drive the presentation layer.  The components are: 
* Model will be transcribed from the Entities created within the Domain layer within the Use Case and used only in the presentation layer.  
* View in this example is the ViewController and is tasked (hopefully) entirely with UI specific logic and objects.  There shouldn't be any business logic here and this view should be reusable with different entities having similar functionality.  
* ViewModel for our current project is tasked with driving the state for the UI, triggering the use case logic when user initiated, and returning formatted data to the view when available.  

### Data
This is where the magic happens of procuring the information or objects the user has requested into the application to be funneled through the business logic / use cases and ultimately back to the Presenter and UI layer.  In this project, its obtaining the Beneficiaries from a local JSON file.. in other applications it could be network requests, retrieving and storing in a local database.. or even sharing via bluetooth or SSL sockets.  The Use cases will interact with these objects and prepare the data for use in the presentation layer.  


Project was inspired by https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3
image sourced from https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html



