<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/13/2018
 * Time: 12:19
 */
namespace Home\InterfaceController;
use Common\Controller\CommonController;
class FortranscationController extends CommonController {

    public function  ifAuth($userid){
        if (I('session.userid')!=$userid) {
            $this->ajaxReturn(json_style(401, "no persiion", 10001));
        }
    }

    public function ifTranscation($transactionid){
        $tb_transcation = M('transcation');
        $where['id'] = $transactionid;
        $res = $tb_transcation->where($where)->find();
        if (!isset($res)){
            $this->ajaxReturn(json_style(400,"没有改交易",10001));
        }
        return $res;
    }

    public  function  Uploadpicture(){
        $upload = new \Think\Upload();//
        $upload->maxSize   =     3145728 ;//
        $upload->exts      =     array('jpg', 'gif', 'png', 'jpeg');//
//        $upload->saveName='';
      //  $upload->replace='true';
        $upload-> autoSub = 'false';
        $upload->subName = null;
        $upload->savePath  ='/receipts/';
        $file =  $_FILES['attachfile'];
        $info= $upload->uploadOne($file);
        if(!$info){// 上传错误提示错误信息
          //  $this->error();
            $this->ajaxReturn(json_style(400,"error when upload file",10016));
        }else{
            return $info;
        }
    }

    public  function  ifAttachment($attachmentid){
        $tb_receipt = M('receipt');
        $where['attachmentid'] = $attachmentid;
        $res =$tb_receipt->where($where)->find();
        if (isset($res)){
            //删除文件 on s3
            deleteons3($res['localurl']);
            //删除本地文件
            unlink($res['localurl']);
        return $res;
        }else{
            $this->ajaxReturn(json_style(400,"没有该文件",10001));
        }
    }

}