<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/13/2018
 * Time: 16:37
 */
require 'vendor/autoload.php';
use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

function connect(){

    $IAM_KEY = C('IAM_KEY');
    $IAM_SECRET = C('IAM_SECRET');
    $s3 = S3Client::factory(
        array(
            'credentials' => array(
                'key' => $IAM_KEY,
                'secret' => $IAM_SECRET
            ),
            'version' => 'latest',
            'region'  => 'us-east-1'
        )
    );
  return $s3;
}

function uploadTos3($path){
    $bucketName = C('BucketName');
    $filePath =$path;
    $keyName = basename($filePath);
    $s3 = connect();
    try {

        // Put on S3
        $result = $s3->putObject(
            array(
                'Bucket'=>$bucketName,
                'Key' =>  $keyName,
                'SourceFile' => $filePath,
                'StorageClass' => 'REDUCED_REDUNDANCY'
            )
        );
        return  $result->get("ObjectURL");
    } catch (S3Exception $e) {
        echo $e->getMessage();
    } catch (Exception $e) {
        echo $e->getMessage();
    }

}

function deleteons3($path){
    $s3 = connect();
    $bucketName = C('BucketName');
    $keyName = basename($path);
    $result = $s3->deleteObject(
        array(
            'Bucket' => $bucketName,
            'Key'    => $keyName
        )
    );

}