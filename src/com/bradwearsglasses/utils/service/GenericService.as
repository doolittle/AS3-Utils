package com.bradwearsglasses.utils.service
{
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.HTTPStatusEvent;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.net.navigateToURL;

  public class GenericService extends EventDispatcher
  {
 
    public var loader:URLLoader;
    protected var url_request:URLRequest;
    protected var in_progress:Boolean = false;
    public function GenericService(format:String=null)
    {
      loader = new URLLoader;
      if (format) loader.dataFormat = format
      loader.addEventListener(Event.OPEN, request_open);
      loader.addEventListener(Event.COMPLETE, request_complete);
      loader.addEventListener(IOErrorEvent.IO_ERROR, io_fail);
      loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, request_fail);
      loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, response_status);
      loader.addEventListener(ProgressEvent.PROGRESS,response_progress);
    }
    
    public function get data():* {
      return (loader) ? loader.data : null
    }
    
    public function set_format(f:String):void {
      loader.dataFormat = f
    }
    
    public function external_link(path:String, params:Object=null, new_window:Boolean=false):void {
      var method:String =URLRequestMethod.GET;
      var window_name:String = (new_window) ? "_blank" : "_self";
      navigateToURL(create_url_request(path, params, method,null), window_name);     
    }
        
    public function request(path:String, params:Object=null, method:String="GET"):void {
      try {			
        in_progress=true;
        var request:URLRequest = create_url_request(path, params, method)        
        loader.load(request);
   
      } catch (e:Error) { 
        trace ("Could not submit request:" + e.message + "\n" + e.getStackTrace() + "\n")
      }
    }

    public function create_url_request(path:String, params:Object=null, method:String="GET", append:String=null):URLRequest {

      var url_request:URLRequest = new URLRequest;
      var u:String = path;
      if (append) { u+=append; }
      if (!params) { params = {}; }
		
      var variables:URLVariables = new URLVariables();
      if (params) {
        for (var p:String in params) {
          if (params[p] || params[p]===0) variables[p] = params[p];
        }
      }			

      url_request.data = variables;  	
      url_request.url = u;		
      url_request.method = method;
      return url_request;			
    }

    private function request_open(event:Event):void {
      dispatchEvent(event);
    }

    private function io_fail(event:IOErrorEvent):void { 
      var gEvent:GenericServiceEvent = new GenericServiceEvent(GenericServiceEvent.IO_WARNING);
      gEvent.event = event;
      dispatchEvent(gEvent);	

      request_fail(event);		
    }

    private function response_status(event:HTTPStatusEvent):void  {
      dispatchEvent(event);

      switch (event.status) {
        case 401: //Unauthorized
          permission_fail(event);
          break;
        case 403: 
        case 500: //General exception
        case 501: // Dunno...	
        case 502: // Gateway failure
        case 503: // Service Unavailable
        case 504: // Gateway failure
          request_fail(event);
          break;
      }
    }

    private function response_progress(event:ProgressEvent):void {
      //trace("progress | bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
      dispatchEvent(event);
    }

    private function request_complete(event:Event):void {

      var gEvent:GenericServiceEvent
      if (loader.data) {
        gEvent = new GenericServiceEvent(GenericServiceEvent.REQUEST_COMPLETE);
        gEvent.event=event;
        if (loader.dataFormat==URLLoaderDataFormat.BINARY) gEvent.data = loader.data
        fire_success(gEvent)
        in_progress=false;	
      } else {
        trace("\n\n### Request complete, but no data ###\n\n")
      }
    }

    private function fire_success(event:GenericServiceEvent):void {
      try { 
        event.data = loader.data
        event.xml=XML( loader.data );
      } catch (e:Error) { //If we don't get XML back pass empty XML. Not all requests return XML, but if string can't be converted to XML throws an error. 
        event.xml=new XML;
      }

      dispatchEvent(event);   
    }
    

    private function fire_fail(event:Event):void {
      dispatchEvent(event);	
    }

    private function request_fail(event:Event=null):void {
      trace("Request failed")
      var gEvent:GenericServiceEvent = new GenericServiceEvent(GenericServiceEvent.REQUEST_FAIL);
      gEvent.event=event;
      dispatchEvent(gEvent);
      in_progress=false;
    }

    private function permission_fail(event:Event):void {
      var gEvent:GenericServiceEvent = new GenericServiceEvent(GenericServiceEvent.PERMISSION_FAIL);
      gEvent.event =event;
      dispatchEvent(gEvent);		
      request_fail(event);	
    }		
  }
}
