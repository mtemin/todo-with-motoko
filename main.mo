import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
// 
actor mtemin{
  type ToDo = {
    description:Text;
    isCompleted:Bool;
  };

  func natHash(n:Nat) : Hash.Hash {
    Text.hash(Nat.toText(n))
  };

  // var -> mutable, let -> immutable
  var todos = Map.HashMap<Nat,ToDo>(0,Nat.equal,natHash);
  var nextId : Nat = 0;

  public query func getTodos():async[ToDo] {
    Iter.toArray(todos.vals());
  };


  public func addTodo(description : Text) : async Nat {
    let id = nextId;
    todos.put(id, { description = description; isCompleted = false });
    nextId += 1;
    id // return id;
  };

  public func completeTodo(id : Nat) : async () {
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, { description; isCompleted = true });
    }
  };
  
  public query func showTodos() : async Text {
    var output : Text = "\n___TO-DOs___";
    for (todo : ToDo in todos.vals()) {
      output #= "\n" # todo.description;
      if (todo.isCompleted) { output #= " ✔"; };
    };
    output # "\n"
  };

  public func clearCompleted() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
              func(_, todo) { if (todo.isCompleted) null else ?todo });
  };

}