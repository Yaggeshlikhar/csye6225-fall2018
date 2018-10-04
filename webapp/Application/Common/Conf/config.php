<?php
return array(
    'URL_MODEL' => 2,//url模式
    'TMPL_FILE_DEPR'      => '_',            // 模板下面模块和操作的分隔符，默认值为 '/'
    'DEFAULT_CONTROLLER' => 'Index', // 默认控制器名称
    'DEFAULT_ACTION' => 'index', // 默认操作名称

    //'配置项'=>'配置值'
    //database
    'DB_TYPE' => 'mysql',     // 数据库类型
    'DB_HOST' => 'localhost', // 服务器地址
    'DB_NAME' => 'dk',          // 数据库名
    'DB_USER' => 'dkbw',      // 用户名
    'DB_PWD' => 'du921230304',    //密码
    'DB_PORT' => '3306',        // 端口
    'DB_PREFIX' => '',    // 数据库表前缀
    'DB_PARAMS' => array(), // 数据库连接参数
    'DB_DEBUG' => TRUE, // 数据库调试模式 开启后可以记录SQL日志
    'DB_FIELDS_CACHE' => true,        // 启用字段缓存
    'DB_CHARSET' => 'utf8mb4',      // 数据库编码默认采用utf8
    'DB_BIND_PARAM' => true     //模型的更新和写入采用自动参数绑定

);