package com.bradwearsglasses.utils.helpers
{
  
  public class DateHelper{
    
    public static const CURRENT_YEAR:Number = (new Date()).getFullYear()	
  
    public static var SHORT_MONTHS:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]; 
    public static var FULL_MONTHS:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]; 

    public static function older_than(original_date:Date, older_than_seconds:Number):Boolean {
      if (!original_date){ return true; }
      var now:Date = new Date;
      return ((now.getTime() - original_date.getTime()) > (older_than_seconds*1000))
    }

    public static function falls_before(subject_date:Date, compare_to_date:Date):Boolean {
      if (!subject_date) return false;
      if (!compare_to_date) return true;
      return (subject_date.getTime() < compare_to_date.getTime()) //TODO: order of params is confusing. 
    }

    public static function diff(start:Date, finish:Date):Number {
      if (!start || !finish) return 0;
      return (finish.getTime() - start.getTime());
    }

    public static function seconds_ago(start:Date):Number {
      return Math.round(milliseconds_ago(start)/1000)
    }
    
    public static function timestamp_utc(seconds:Boolean=true):Number {
      var now:Date = new Date(); 
      return Math.round((now.getTime()/((seconds) ? 1000 : 1))); 
    }

    public static function milliseconds_ago(start:Date):Number {
      if (!start) return 0;
      var curdate:Date = new Date()
      return Math.round(Math.abs(curdate.time - start.time))
    }   

    public static function minutes_ago(start:Date):Number {
      return Math.round(seconds_ago(start)/60)
    }  

    public static function hours_ago(start:Date):Number {
      return Math.round(seconds_ago(start)/(60*60))
    }  

    public static function days_ago(start:Date):Number {
      return Math.round(seconds_ago(start)/(60*60*24))
    }   

    public static function weeks_ago(start:Date):Number {
      return Math.round(seconds_ago(start)/(60*60*24*7))
    }  

    public static function years_ago(start:Date):Number {
      return (seconds_ago(start)/(60*60*24*365))
    }

    public static function time_ago_in_words(from_time:Number, include_seconds:Boolean=false):String {
      var curdate:Date = new Date()
      return distance_of_time_in_words(from_time, curdate.time, include_seconds) + " ago"; 
    }   

    public static function absolute_timestamp(date:Date):String {
      //06:10 PM - Oct 16 (or Today)
      if (!date) return null
      var s:String = local_hours(date.hours) + ":" + local_minutes(date.minutes) + " " + meridiem(date.hours) + " - " + simple_calendar_date(date); 
      return s;
    }

    public static function month_num_for(partial:String):Number {
      var i:Number = -1, month:String
      while (++i < FULL_MONTHS.length) {
        month = (FULL_MONTHS[i] as String).toLowerCase()
        if (month.indexOf(partial.toLowerCase()) !=-1) return i+1
      }

      return -1
    }

    private static function local_minutes(m:Number):String {
      return (m < 10) ? "0" + m.toString() : m.toString();
    }

    private static function local_hours(h:Number):Number {
      if (h==0) { return 12; }
      return (h > 12) ? (h-12) : h;
    }

    private static function meridiem(h:Number):String {
      return (h > 11) ? "PM" : "AM";
    }

    private static function simple_calendar_date(date:Date):String {
      if (!date) return null;
      var curdate:Date = new Date();
      return (curdate.toDateString ()  == date.toDateString()) ? "Today" : local_short_month(date.month) + " " + date.date;
    }

    private static function local_short_month(m:Number):String {
      return SHORT_MONTHS[m];
    }

    private static function distance_of_time_in_words(from_time:Number, to_time:Number, include_seconds:Boolean=false):String { //Stolen from rails
      if (! to_time) to_time = 0;  
      var in_mins:Number = Math.round(((Math.abs(to_time - from_time))/60000))
      var in_secs:Number =  Math.round(((Math.abs(to_time - from_time))/1000))

      if (btw(in_mins,0,1)) {
        if (!include_seconds) return (in_mins == 0) ? 'a moment' : '1 minute'; 
        if (btw(in_secs,0,4))   return '5 seconds';
        if (btw(in_secs,5,9))   return '10 seconds';
        if (btw(in_secs,10,19)) return '20 seconds';
        if (btw(in_secs,20,29)) return '30 seconds';
        if (btw(in_secs,30,39)) return '40 seconds';
        if (btw(in_secs,40,49)) return '50 seconds';
        return '1 minute';
      }
      if (btw(in_mins,2,44))           return in_mins + " minutes";
      if (btw(in_mins,45,89))          return '1 hour';
      if (btw(in_mins,90,1439))        return Math.round(in_mins / 60.0) + " hours";
      if (btw(in_mins,1440,2879))      return '1 day';
      if (btw(in_mins,2880,43199))     return Math.round(in_mins / 1440) + " days";
      if (btw(in_mins,43200,86399))    return '1 month';
      if (btw(in_mins,86400,525599))   return Math.round(in_mins / 43200) + " months";
      if (btw(in_mins,525600,1051199)) return '1 year';
      return "over " + Math.round(in_mins / 525600) + " years";
    }

    private static function btw(num:Number,min:Number,max:Number):Boolean {
      if (min > num || max < num) {
        return false;
      } else {
        return true;
      }
    }    
  }
}
