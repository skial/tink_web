package tink.web.macros;

import tink.Url;
import tink.http.Method;
import haxe.macro.Context;

using StringTools;

/**
* Represents the details of a segment from a path.
* Path == /article/2016-05-05/
* Segment == article/
* Segments == [article/, 2016-05-05/]
* Methods == @see `tink.http.Method`
*/
private class IntegrationDetails {
	
	public var methods:Array<Method> = [];
	public var segments:Map<String, IntegrationDetails> = new Map();
	
	public inline function new() {}
	
}

class IntegrationBuilder {
	
	public static function __init__():Void {
		Context.onAfterGenerate(function() {
			trace( root );
		});
	}
	
	private static var root:Map<String, IntegrationDetails> = new Map();
	
	public static function add(url:Url, method:Method, ?map:Map<String, IntegrationDetails>):Void {
		map = map == null ? root : map;
		if (!url.startsWith('/')) url = '/$url';
		var parts = url.path.parts();
		var integration:IntegrationDetails = null;
		
		for (i in 0...parts.length) {
			var part = parts[i];
			
			switch part {
				case x if(x != ''):
					if (!map.exists( part ))
						map.set( part, new IntegrationDetails() );
					
					integration = map.get( part );
					if (integration.methods.lastIndexOf( method ) == -1)
						integration.methods.push( method );
						
					if (i < parts.length - 1)
						map = integration.segments;
					
			}
			
		}
		
	}
	
}
