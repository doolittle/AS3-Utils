package com.bradwearsglasses.utils.css
{
  import flash.text.StyleSheet;
  
  public class bwgCSS { 
    
    private static var _globalStyles:StyleSheet;
    public static function get globalStyles():StyleSheet {
      if (!_globalStyles) initialize(); 
      return _globalStyles;
    }

    private static function initialize():void {
      _globalStyles = new StyleSheet;
      _globalStyles.parseCSS("" +
        "a:hover { text-decoration: underline; } " +
        ".lHeadline { color:#1166bb; font-family: Arial,Helvetica,sans-serif; font-size: 22px;} " +
        ".lbHeadline { color:#2e2e2e; font-family: Arial,Helvetica,sans-serif; font-size: 22px;} " +
        ".mHeadline {color:#1166bb; font-family: Arial,Helvetica,sans-serif; font-size:14px; font-weight:bold; } " +
        ".bHeadline {color:#2e2e2e; font-family: Arial,Helvetica,sans-serif; font-size:14px; font-weight:bold; } " +
        ".lightHeadline {color:#666666; font-family: Arial,Helvetica,sans-serif; font-size:14px; font-weight:bold; } " +
        ".sHeadline {color:#1166bb; font-family: Arial,Helvetica,sans-serif; font-size:12px; font-weight:bold; } " +
        ".giant {color:#AAAAAA; font-family: \"Arial Narrow\", Arial,Helvetica,sans-serif; font-size:72px;} " +
        ".large {color:#000000; font-family: Arial,Helvetica,sans-serif; font-size:14px;} " +
        ".default {color:#000000; font-family: Arial,Helvetica,sans-serif; font-size:12px;} " +
        ".bold {color:#000000; font-family: Arial,Helvetica,sans-serif; font-size:12px;font-weight:bold;} " +
        ".blue {color:#1166bb; font-family: Arial,Helvetica,sans-serif; font-size:12px;} " +
        ".blue_small {color:#1166bb; font-family: Arial,Helvetica,sans-serif; font-size:10px;} " +
        ".error {color:#b60e0e; font-family: Arial,Helvetica,sans-serif; font-size:12px; font-weight:bold; } " +
        ".fButton {color:#FFFFFF; font-family: Arial,Helvetica,sans-serif; font-size:12px; font-weight:bold; } " +
        ".tButton {color:#FFFFFF; font-family: Arial,Helvetica,sans-serif; font-size:11px; font-weight:bold; } " +
        ".small {color:#000000; font-family: Arial,Helvetica,sans-serif; font-size:10px;} " +
        ".super_small {color:#000000; font-family: Arial,Helvetica,sans-serif; font-size:8px;} " +
        ".label {color:#696969; font-family: Arial,Helvetica,sans-serif; font-size:11px;}");
    }
  }
}
