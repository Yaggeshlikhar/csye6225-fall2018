<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 09/27/2018
 * Time: 18:08
 */

namespace Home\Controller;



use Aws\AwsClient;
use Aws\DynamoDb\DynamoDbClient;
use Aws\DynamoDb\Exception\DynamoDbException;
use Aws\DynamoDb\Marshaler;
use Aws\Sdk;
use Aws\Ses\SesClient;
use Aws\Sns\SnsClient;
use Think\Controller;


class UserController extends Controller
{

    //login API
  

    // register API
    public function register()
    {
         $metrics = ststad();
         $metrics->increment('register');
         $metrics->flush();
        if (!IS_POST) {
            $this->ajaxReturn(json_style(400, "bad request, incorrect submit method", 10015));
        }

        $postData = file_get_contents("php://input");
        $resultData = json_decode($postData, true);
        if (!isset($resultData['email']) || !isset($resultData['password'])) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }

        $data['email'] = $resultData['email'];
        createUser();
        $tb_user = M('user');
        //first retrive from dB
        $res = $tb_user->where($data)->find();
        if (isset($res)) {
            $this->ajaxReturn(json_style(401, "your emial has been used ,please change one", 10005));
        } else {
            $data['password'] = password_hash($resultData['password'], PASSWORD_BCRYPT);
            $res = $tb_user->add($data);
            if ($res) {

                $token =getRandomString(20);
                 $_SESSION['tokenID'] = $token;
                $_SESSION['userid'] = $res;
                $this->ajaxReturn(json_style(200, "Success!!", 10006));
            } else {
                $this->ajaxReturn(json_style(500, "database error", 10007));
            }
        }
    }

public  function restPassword(){
         $metrics = ststad();
         $metrics->increment('resetPassword');
         $metrics->flush();
     
     $where['id']  = I('session.userid',null);
      if (isset($where['id'])){
           $provider = \Aws\Credentials\CredentialProvider::defaultProvider();
           $tb_user =M('user');
           $res = $tb_user->where($where)->find();
           $email = $res['email'];
           $dyclient =DynamoDbClient::factory(
            array(
              'credentials' => $provider,
              'region'   => 'us-east-1',
              'version'  => 'latest'
            )
           );
            $iterator = $dyclient->getIterator('Query', array(
            'TableName'     => 'csye6225',
            'KeyConditions' => array(
                'userEmail' => array(
                    'AttributeValueList' => array(
                        array('S' => $email)
                    ),
                    'ComparisonOperator' => 'EQ'
                )

            )
        ));
         
        $i =0;
        $link ="";
        foreach ($iterator as $item) {
            $link = $item['message']['S'];
            $i++;
            break;
        }
        if($i==0){
          $snsclient =SnsClient::factory(
                array(
                    'credentials' => $providfer,
                    'version' => 'latest',
                    'region'  => 'us-east-1'
                )
            );
            $token = getRandomString(30);
           $response = $snsclient->publish(
             array(
              'TopicArn'=>C('TopicArn'),
              'Message'=>'http://'.$_SERVER['HTTP_HOST'].'/reset/email/'.$email.'/token/'.$token,
              'Subject'=>'Set Password',
              'MessageAttributes'=>array(
                      'EmailAddress'=>array(
                      "DataType"=>'String',
                      "StringValue"=>$email
                  ),
                     "Source"=>array(
                         "DataType"=>'String',
                         "StringValue"=>C('Source')
                        // "StringValue"=>'northeastern@csye6225-fall2018-likhary.me'
                       ),
                   "ExpirationTime"=>array(
                      "DataType"=>'String',
                      "StringValue"=>20*60
                  ),
                  "Token"=>array(
                      "DataType"=>'String',
                      "StringValue"=>$token
                  )


              )
          )

      );  
        }else{
        $this->ajaxReturn(json_style(200,"you have already recieve a email before",10004));
        } 
     }else{
         $this->ajaxReturn(json_style(500,"please login first",10004));
     }
   
 
    }


 

}
