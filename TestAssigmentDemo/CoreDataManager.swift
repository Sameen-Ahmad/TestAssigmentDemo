


import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        // Create the model programmatically
        let model = NSManagedObjectModel()
        
        // Define the FavoriteMovie entity
        let favoriteMovieEntity = NSEntityDescription()
        favoriteMovieEntity.name = "FavoriteMovie"
        favoriteMovieEntity.managedObjectClassName = NSStringFromClass(FavoriteMovie.self)

        // Add attributes to the entity
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .integer64AttributeType
        idAttribute.isOptional = false

        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.attributeType = .stringAttributeType
        titleAttribute.isOptional = true

        let posterPathAttribute = NSAttributeDescription()
        posterPathAttribute.name = "posterPath"
        posterPathAttribute.attributeType = .stringAttributeType
        posterPathAttribute.isOptional = true

        let releaseDateAttribute = NSAttributeDescription()
        releaseDateAttribute.name = "releaseDate"
        releaseDateAttribute.attributeType = .stringAttributeType
        releaseDateAttribute.isOptional = true

        // Assign attributes to the entity
        favoriteMovieEntity.properties = [idAttribute, titleAttribute, posterPathAttribute, releaseDateAttribute]

        // Add the entity to the model
        model.entities = [favoriteMovieEntity]

        // Initialize the persistent container with the programmatically created model
        persistentContainer = NSPersistentContainer(name: "DynamicModel", managedObjectModel: model)

        // Load persistent stores
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    func saveFavorite(movie: Movie) {
        let context = CoreDataManager.shared.persistentContainer.viewContext

        // Create a new FavoriteMovie instance
        let favoriteMovie = FavoriteMovie(context: context)
        favoriteMovie.id = Int64(movie.id)
        favoriteMovie.title = movie.title
        favoriteMovie.posterPath = movie.posterPath
        favoriteMovie.releaseDate = movie.releaseDate

        do {
            try context.save()
            print("Favorite movie saved successfully!")
        } catch {
            print("Failed to save favorite movie: \(error)")
        }
    }


    func fetchFavorites() -> [FavoriteMovie] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie") // Correctly typed fetch request

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }


    func removeFavorite(movieId: Int) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie") // Correctly typed fetch request
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)

        do {
            let results = try context.fetch(fetchRequest)
            for movie in results {
                context.delete(movie)
            }
            try context.save()
            print("Favorite movie removed successfully!")
        } catch {
            print("Failed to remove favorite movie: \(error)")
        }
    }


    func isFavorite(movieId: Int) -> Bool {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check favorite status: \(error)")
            return false
        }
    }

//    for entity in CoreDataManager.shared.persistentContainer.managedObjectModel.entities {
//        print("Entity found: \(entity.name ?? "No name")")
//    }

    
    
    
    
    
    
    
}


@objc(FavoriteMovie)
public class FavoriteMovie: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
}


