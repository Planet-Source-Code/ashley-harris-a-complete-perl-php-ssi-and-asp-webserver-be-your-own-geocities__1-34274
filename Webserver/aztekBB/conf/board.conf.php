<?php
/* 
   This is the boards main configuration file, it is probly best to use the
   editor include in the admin script to edit these values to prevent a
   misconfiguration
*/
$boardTitle         = "You Message Board Title";              // The page title for the board
$boardMsg           = "Welcome to my board";                  // The welcome message for the board
$boardBaseUrl       = "http://127.0.0.1/aztekBB";               // The base url for the board (do not add the endting slash)
$boardHostUrl       = "http://127.0.0.1";              // The host url for where the board is called from (usually your homepage)
$boardHostTitle     = "Back to Your Site Name";               // The host title for where the board is called from (usually "Back to your homepage")
$boardMsgUrl        = "./msgs";                               // The path to the message directory
$boardSmilieUrl     = "./smilies";                            // The path to the smiles directory
$boardSmilie        = TRUE;                                   // Have the script translate popular smile expression into premade images (TRUE=yes, FALSE=no)
$boardStripTags     = TRUE;                                   // Have the script strip all PHP and HTML tags from posted messages
$boardAllowableTags = "<b><u><a><i><font><div><p><br><pre>";  // Do allow posters to use these and ONLY these HTML tags
?>