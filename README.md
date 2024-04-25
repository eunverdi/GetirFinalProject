<br>
GetirFinalProject </h1>
<h6 align="left"> 

## Personal Objectives
- Learning and writing code with VIPER Architecture
- Learning and writing Unit Test

## Outline 
- The project was designed and completed with the VIPER architecture in order to adhere to a manageable Clean Code structure.

- After the final adjustments, the project took its final form, albeit with Unit Tests that are not yet completed.

- In order to maintain the structure of modularity, each structure was designed in a simple and understandable way to manage its own tasks and responsibilities.

- For CleanCode, SwiftLint was added to the project with certain rules, and an effort was made to comply with these rules as much as possible.


## Getting Started

```bash
mkdir GetirFinalProject
cd GetirFinalProject
git clone https://github.com/eunverdi/GetirFinalProject.git
open .
```

## Project Requirements
- Users must navigate to products details
- Users must add products to the cart
- Users must delete a single item

## Architecture
VIPER. In addition, Storyboard and XIB structures were not used. The entire interface was designed programmatically.

## Tech stack
- UICollectionViewCompositionalLayout, which is available in iOS 13+, was used. 
- For the network structure, Moya, which uses Alamofire at its core, was preferred. 
- The management of all images was done with SDWebImage. 
- The products to be added to the cart, and the recording of all their information, and the use of this data when needed, was provided by CoreData.

## Usage
![GetirFinalProject Usage](https://github.com/eunverdi/GetirFinalProject/assets/89488125/fc2a2d19-282f-4b86-9745-7555e5e691ad)
