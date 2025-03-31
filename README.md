# News App

A modern iOS news application built with SwiftUI that provides real-time news updates from various categories and sources.

<img src="https://github.com/user-attachments/assets/8fe7191e-c666-4a50-886b-e514b99b3067" alt="App Icon" width="120" height="120" style="margin-bottom: 10px;">  


## Features

<img width="1000" src="https://github.com/user-attachments/assets/53cb7371-9bdf-4533-b563-b862622f7559">  

### Core Features
- 📰 Real-time news updates from multiple categories
- 🔍 Advanced search functionality
- 📱 Modern SwiftUI interface
- 🌐 Offline support with efficient caching
- 📱 Infinite scrolling pagination
- 🎨 Beautiful and intuitive UI design

### Categories
- All News
- Business
- Entertainment
- General
- Health
- Science
- Sports
- Technology

## Architecture

### MVVM Architecture
The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures for news articles and API responses
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Services that handle data fetching and business logic

### Key Components

#### Services
1. **NewsAPIService**
   - Handles general news search functionality
   - Manages pagination and caching
   - Processes API responses

2. **NewsCategoriesAPIService**
   - Manages category-specific news
   - Handles filtering by categories
   - Implements pagination and caching

3. **CacheService**
   - Thread-safe caching implementation using Swift actors
   - Persists data to disk
   - Provides efficient data retrieval

#### Views
1. **MainView**
   - Search interface
   - News list with infinite scrolling
   - Loading states and error handling

2. **CategoriesView**
   - Category selection with smooth animations
   - Category-specific news feed
   - Pull-to-refresh functionality

3. **ArticleRow**
   - Custom article presentation
   - Image loading with fallback
   - Metadata display (source, author, date)

### Data Flow
1. User interacts with the UI
2. ViewModel (Service) processes the request
3. Cache is checked for existing data
4. If needed, API request is made
5. Response is processed and cached
6. UI is updated with new data

### Technical Features
- **SwiftUI**: Modern declarative UI framework
- **Async/Await**: Asynchronous programming
- **Actors**: Thread-safe data handling
- **SwiftData**: Data persistence
- **URLSession**: Network requests
- **JSON**: Data serialization

## API Integration
The app uses the NewsAPI.org service for fetching news data:
- Top headlines endpoint
- Everything endpoint for search
- Category-based filtering
- Pagination support

## Performance Optimizations
- Efficient data caching
- Lazy loading of images
- Pagination for large datasets
- Thread-safe operations
- Memory management

## Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- NewsAPI.org API key

## Installation
1. Clone the repository
2. Add your NewsAPI.org API key
3. Build and run the project

## Dependencies
- SwiftUI
- SwiftData
- URLSession

## Contributing
Feel free to submit issues and enhancement requests! 
