package tink.web.helpers;

import tink.url.Query;

class QueryParserBase<T> { 
  
  var params:Map<String, T>;
  var exists:Map<String, Bool>;
  
  public function new(q:Iterator<{ var name(default, null):String; var value(default, null):T; }>) {
    
    this.params = new Map();
    this.exists = new Map();
    
    if (q != null)
      for (param in q) {
        
        var name = param.name;
        
        params[name] = param.value;
        
        var end = name.length;
        
        while (end > 0) {
          
          name = name.substring(0, end);
          
          if (exists[name]) break;
          
          exists[name] = true;
          
          switch [name.lastIndexOf('[', end), name.lastIndexOf('.', end)] {
            case [a, b] if (a > b): end = a;
            case [_, b]: end = b;
          }
        }
      }
  }
  
  function missing(name:String):Dynamic {
    return throw new tink.core.Error(UnprocessableEntity, 'Missing parameter $name');
  }
  
}