package com.bradwearsglasses.utils.helpers
{
  
  import flash.utils.ByteArray;
  import flash.utils.describeType;
  import flash.utils.getDefinitionByName;
  import flash.utils.getQualifiedClassName;
  
  public class ArrayHelper
  {

    public static function random(a:Array):Object {
      return (!a) ? null : a[NumberHelper.random(0, a.length-1)]
    }
    
    public static function randomPop(a:Array):Object {
      return (!a) ? null : a.splice(NumberHelper.random(0, a.length-1),1)[0];
    }
    
    public static function random_from_object(o:Object):Object { //This should only be used in weird cases where it isn't practical to make an array
      var random:Number = NumberHelper.random(0, count_object(o))
      var n:Number = 0;
      for each (var e:* in o) { if (++n==random) return e }   
      return null   
    }

    public static function obj_has_values(o:Object):Boolean { 
      for each (var e:* in o) { return true; }
      return false;
    }

    public static function count_object(o:Object):Number { 
      var n:Number = 0;
      for each (var e:* in o) { n++; }
      return n;
    } 
    
    public static function find(array:Array, needle:*):Boolean   {   
      if (!array || !needle) { return false; }
      var i:Number=-1;
      var num_elements:Number=array.length
      while (++i < num_elements) { 	if (array[i]==needle) { return true; }		}
      return false;
    }

    public static function sum(array:Array):Number {
      var i:Number=-1;
      var l:Number = array.length;
      var n:Number= 0;
      while (++i < l) {
        n+=Number(array[i])
      }
      return n;
    }

    public static function clone(array:Array):Array {
      return array.filter(function(o:Object, ...rest):Boolean { return true; })
    }
    
    public static function cloneObject(source:Object):*{
      var BA:ByteArray = new ByteArray();
      BA.writeObject(source);
      BA.position = 0;
      return(BA.readObject());
    }

    public static function remove_subset(subset:Array, complete:Array):Array { //TODO: wow, this will be slow on long arrays.
      var diff:Array=[], i:Number = -1, j:Number, matched:Boolean;
      while (++i < complete.length) {
        j = -1;
        matched = false;
        while (++j < subset.length) {
          if (subset[j]==complete[i]) {
            subset = ArrayHelper.rebuild_array_without(subset, subset[j])
            matched = true;
            continue;
          } 
        }
        if (!matched) diff.push(complete[i]);
      }
      return diff;
    }

    public static function has_values(object:Object, ...rest):Boolean {
      return (object);
    }

    public static function is_not_duplicated(object:Object,  i:Number, a:Array):Boolean {
      return (a.lastIndexOf(object) ==i); 
    }	

    public static function convert_object_to_post(o:Object, ...rest):String {
      var s:String="";
      for (var item:* in o) {
        s+=item + "=" + o[item] + "&";
      }
      return s;
    }	

    public static function obj_to_array(o:Object):Array {
      var a:Array=[]
      for (var item:* in o) { a.push(o[item]); }
      return a;
    }	

    public static function add_array_to_post(a:Array, params:Object, prefix:String):void {
      var s:String="", i:Number=-1, num_elements:Number=a.length;
      while (++i < num_elements) {
        params[prefix + "[" +i + "]"]=a[i]; 
      }
    }	 

    public static function merge(a:Object, b:Object):Object {
      for (var p:String in b) {
        if (b[p] || b[p]===0) a[p] = b[p];
      }
      return a;
    }

    public static function concat(...rest):Array {
      var a:Array = [], i:Number = -1
      while (++i < rest.length) { a = a.concat(rest[i])  }
      return a;
    }

    public static function rebuild_without(hash:*, match:*):* {
      return (hash.isPrototypeOf(Array)) ? rebuild_array_without(hash as Array, match) : rebuild_object_without(hash, match);  
    }

    public static function rebuild_array_without(a:Array, match:*):Array {
      return a.filter(function(e:*, ...rest):Boolean { return (e===match) ? false : true; }); 
    }

    public static function rebuild_object_without(o:Object, match:*):Object {
      var rebuilt:Object = {};
      for (var e:* in o) {
        if (o[e]!=match) { rebuilt[e]=o[e]; }
      }
      return rebuilt;
    }
    
    public static function shuffle(array:Array):Array {
        var length:int = array.length,cloned_array:Array = array.slice(),shuffled:Array = new Array(length),i:int;
        for (i = 0; i<length; i++) {
          shuffled[i] = cloned_array.splice(int(Math.random() * (length - i)), 1)[0];
        }
        return shuffled;
      }
    }
}
