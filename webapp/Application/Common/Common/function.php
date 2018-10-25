<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/03/2018
 * Time: 16:31
 */
 function  json_style($code,$msg,$subcode,$data =null){
    return array(
        'code' => $code,
        'msg'=>$msg,
        'subcode'=>$subcode,
        'data'=>$data
    );

}

//
/*
     * 创建数据库，并且主键是aid
     * table 要查询的表名
     */
//user table
function createUser(){
    $sql='create table if not exists user
(
	id int auto_increment primary key,
	email varchar(255) not null,
	password varchar(255) not null
);';
    M()->execute($sql);

}



//

function createTransaction(){
    $sql='create  table if not exists transaction
(
	id varchar(100) not null
		primary key,
	description text not null,
	merchant varchar(100) not null,
	amount varchar(100) not null,
	date varchar(100) not null,
	category varchar(100) not null,
	userid int not null
);';
    M()->execute($sql);

}

function createReceipt(){
    $sql='create table if not exists receipt
(
	attachmentid int auto_increment
		primary key,
	transactionid varchar(255) not null,
	localurl varchar(255) not null,
	s3url varchar(255) not null
);';
    M()->execute($sql);

}




