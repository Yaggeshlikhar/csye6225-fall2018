<?php
require 'vendor/autoload.php';
$doten = new  \Dotenv\Dotenv('/opt/lampp/htdocs');
$doten->load();


$webName = in_array($_SERVER['HTTP_HOST'],array('localhost'));
$configArr = array(
        'URL_MODEL' => 2,
        'TMPL_FILE_DEPR'      => '_',
        'DEFAULT_CONTROLLER' => 'Index',
        'DEFAULT_ACTION' => 'index',
        //网站域名
        'SITEURL' => 'http://' . $_SERVER['HTTP_HOST'].'/',

);

if ($webName == true) {
    $dbData = array(
        
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
    
} else {
    $dbData = array(
        //    //database
        'DB_TYPE' => 'mysql',     // 数据库类型
        'DB_HOST' => getenv("DB_HOST"),
        'DB_NAME' => getenv("DB_NAME"),
        'DB_USER' => getenv("DB_USER"),
        'DB_PWD' => getenv("DB_PWD"),
        'DB_PORT' => getenv("DB_PORT"),
        'DB_PREFIX' => '',    // 数据库表前缀
        'DB_PARAMS' => array(), // 数据库连接参数
        'DB_DEBUG' => TRUE, // 数据库调试模式 开启后可以记录SQL日志
        'DB_FIELDS_CACHE' => true,        // 启用字段缓存
        'DB_CHARSET' => 'utf8mb4',      // 数据库编码默认采用utf8
        'DB_BIND_PARAM' => true,     //模型的更新和写入采用自动参数绑定
        'BucketName' => getenv("s3_name"),
        'IAM_KEY'=>getenv("IAM_KEY"),//change yourself
        'IAM_SECRET' =>getenv("IAM_SECRET")////change yourself
    );

}
$config_all = array();
$config_all = array_merge($configArr, $dbData);

return $config_all;
