<?php
return array(
    'URL_MODEL' => 2,//url mode
    'TMPL_FILE_DEPR'      => '_', //The separator for the module and operation below the template. The default value is '/'
    'DEFAULT_CONTROLLER' => 'Index', //  Default controller name
    'DEFAULT_ACTION' => 'index', //  Default operation name

   //'Configuration item'=>'Configuration value'
    //database
    'DB_TYPE' => 'mysql',     //  db tyoe
    'DB_HOST' => '127.0.0.1', //  server address
    'DB_NAME' => 'test',          //   db name
    'DB_USER' => 'root',      //   user name
    'DB_PWD' => 'du921230304',    // password
    'DB_PORT' => '3306',        //  api
    'DB_PREFIX' => '',    //    Database table prefix
    'DB_PARAMS' => array(), //   db connection parameter
    'DB_DEBUG' => TRUE, //   Database debugging mode can be used to log SQL logs
    'DB_FIELDS_CACHE' => true,        //  Enable field caching
    'DB_CHARSET' => 'utf8mb4',      //  Database encoding defaults to utf8
    'DB_BIND_PARAM' => true     //Model update and write with automatic parameter binding
);