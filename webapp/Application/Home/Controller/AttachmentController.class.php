<?php
/**
 * Created by PhpStorm.
 * User: dukun
 * Date: 10/13/2018
 * Time: 12:15
 */

namespace Home\Controller;

use Home\InterfaceController\FortranscationController;
use Home\InterfaceController\PutController;

class AttachmentController extends FortranscationController
{

    //Attach a file to the transaction
    public function createAttachfile()
    {

        $this->ifRightsubmit(2);
        $transactionid = I('get.transactionid', null);
        if (!isset($transactionid)) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);
        $info = $this->Uploadpicture();

        $filename = 'Uploads' . $info['savepath'] . $info['savename'];
        //save in data
        if ($_SERVER['HTTP_HOST']!='localhost'){
            $data['s3url'] = uploadTos3($filename);
            unlink($filename);
            $data['localurl'] = null;     
        }else{
            //
            $data['localurl'] = $filename;
            $data['s3url'] = null;
        }

        $data['transactionid'] = $transactionid;
        createReceipt();
        $tb_receipt = M('receipt');
        $res = $tb_receipt->add($data);
        if ($res) {
            $res = $tb_receipt->where(array("attachmentid" => $res))->find();
            $this->ajaxReturn(json_style(201, "success created", 10010, $res));
        } else {
            $this->ajaxReturn(json_style(500, "database error", 10008));
        }
        
    }

    //Get list of files attached to the transaction
    public function listAttachement()
    {
        $this->ifRightsubmit(1);
        $transactionid = I('get.transactionid', null);
        if (!isset($transactionid)) {
        $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);
        createReceipt();
        $tb_receipt = M('receipt');
        $where['transactionid'] = $transactionid;
        $res = $tb_receipt->where($where)->select();
        $this->ajaxReturn(json_style(200, "ok", 10011, $res));
    }

    //Update file attached to the transactio
    public function updateAttachment()
    {
        $this->ifRightsubmit(2);
        $transactionid = I('get.transactionid', null);
        $attachmentid = I('post.attachmentid', null);

        if (!isset($transactionid) || !isset($attachmentid)) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);
        createReceipt();
        $tb_receipt = M('receipt');
        $where['attachmentid'] = $attachmentid;
        $res = $tb_receipt->where($where)->find();
        if(!$res){
            $this->ajaxReturn(json_style(204, "this transaction does not have this attachment file", 10018));
        }

       //$this->ifAttachment($attachmentid);

        $info = $this->Uploadpicture();
        $filename = 'Uploads' . $info['savepath'] . $info['savename'];
        
        if ($_SERVER['HTTP_HOST']!='localhost'){
            deleteons3($res['s3url']);
            $data['s3url'] = uploadTos3($filename);
            unlink($filename);
            
        }else{

            unlink($res['localurl']);
            $data['localurl'] = $filename;
        }
        
        $data['attachmentid'] = $attachmentid;
       // createReceipt();
        //$tb_receipt = M('receipt');
        $res = $tb_receipt->save($data);
        if ($res) {
            $res = $tb_receipt->where(array("attachmentid" => $res))->find();
            $this->ajaxReturn(json_style(201, "success Update", 10012, $res));
        } else {
            $this->ajaxReturn(json_style(500, "database error", 10008));
        }

    }


    //Delete
    public  function  deleteAttachment(){

        $this->ifRightsubmit(4);
        $putData = file_get_contents("php://input");
        $resultData = json_decode($putData,true);
        $transactionid = I('get.transactionid', null);
        if (!isset($transactionid) || !$resultData['attachmentid']) {
            $this->ajaxReturn(json_style(400, "bad request, lack paramters", 10001));
        }
        $res = $this->ifTranscation($transactionid);
        $this->ifAuth($res['userid']);

        createReceipt();
        $tb_receipt = M('receipt');
        $where['attachmentid'] = $resultData['attachmentid'];
        $res = $tb_receipt->where($where)->find();
        
       // $res =$this->ifAttachment($resultData['attachmentid']);

        if ($_SERVER['HTTP_HOST']!='localhost'){
            deleteons3($res['s3url']);
            //$data['s3url'] = uploadTos3($filename);
            //unlink($filename);

        }else{

            unlink($res['localurl']);
         //   $data['localurl'] = $filename;
        }

        //createReceipt();
        //$tb_receipt = M('receipt');
        $tb_receipt->where(array('attachmentid'=>$resultData['attachmentid']))->delete();

        if ($res===false){
            $this->ajaxReturn(json_style(500,"database error",10008));
        }else{
            $this->ajaxReturn(json_style(200,"delete success",10014));
        }

    }





}
