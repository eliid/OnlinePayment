<!--   
*******************************************************************************  
网上支付，两种接入方案：1)直接与银行对接。2)通过中间公司间接与银行对接  
1)直接与银行对接  
   优点：由于是直接与银行进行财务结算，故交易资金比较安全  
         适合资金流量比较大的(比如每月结算金额达到佰万以上)的企业  
   缺点：开发工作量比较大。银行会不定期升级交易系统，故企业也需要作相应改动  
         而且企业每年还需要向银行交纳一定数量的接口应用费  
2)通过中间公司间接与银行对接  
   优点：开发工作量较少。由于使用的是中间企业提供的接入规范，故银行升级系统时不需要企业作相应修改  
         除非中间企业的接入规范发生了改变，企业才作相应修改  
         由于只是与一家中间企业对接，故其接入费用也比较低  
         适合资金流量比较小的(比如每月结算金额在几十万以下的中小企业)  
   缺点：由于是与中间企业进行资金结算，而目前所有中间企业都是私企，故资金安全是个大问题  
********************************************************************************  
目前国内做的比较好的中间支付公司  
首信易支付：http://www.beijing.com.cn  
           每年交纳一定的接口使用费，并从交易金额中扣除1%的手续费。红孩子、当当网、京东商城等用之  
易宝支付：http://www.yeepay.com  
         接入免费，只从交易金额中扣除1%的手续费。盛大、艺龙网、巴巴运动网等用之  
********************************************************************************  
支付流程，大致如下：(可参考//WebRoot//WEB-INF//page//connection.jsp来理解)  
通过HTTP的方式向易宝支付网关发起支付请求，即向connection.jsp中注释部分的测试或正式网关发起请求  
该请求可以是GET或者POST方式，页面应采用GBK或者GB2312编码  
易宝支付网关对企业发来的数据，使用用户的密钥生成HMAC-MD5  
然后与企业发来的HMAC-MD5(即表单中hmac字段提供的值)比较  
若二者相同，则将请求转发到银行网关  
当用户支付完成后，银行网关会引导用户的浏览器重定向到易宝支付网关  
接着易宝支付网关再引导浏览器重定向到企业提供的url页面(即表单中p8_Url提供的值)  
********************************************************************************  
 -->
<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=GBK" /> 
<link rel="stylesheet" type="text/css" href="./css/bank.css" rel="external nofollow" /> 
<title>在线支付</title> 
<script type="text/javascript" src="./js/jQuery_v172_min.js"></script> 
<style type="text/css"> 
	/* Bank Select */ 
	.ui-list-icons li { float:left; margin:0px 10px 25px 0px; width:218px; padding-right:10px; display:inline; } 
	.ui-list-icons li input { vertical-align:middle; } 
	.ui-list-icons li .icon-box { cursor:pointer; width:190px; background:#FFF; line-height:36px; border:1px solid #DDD; vertical-align:middle; position:relative; display:inline-block; zoom:1; } 
	.ui-list-icons li .icon-box.hover, .ui-list-icons li .icon-box.current { border:1px solid #FA3; } 
	.ui-list-icons li .icon-box-sparkling { position:absolute; top:-18px; left:0px; height:14px; line-height:14px; } 
	.ui-list-icons li .icon { float:left; width:163px; padding:0px; height:36px; display:block; line-height:30px; color:#07f; font-weight:bold; white-space:nowrap; overflow:hidden; position:relative; z-index:1; } 
	.ui-list-icons li .bank-name { position:absolute; left:5px; z-index:0; height:36px; width:121px; overflow:hidden; } 
	/* Bank Background */ 
	.ui-list-icons li .ICBC-NET { background:#FFF url(./bankImage/gongshang_bank.gif) no-repeat 0px center; } 
	.ui-list-icons li .CMBCHINA-NET { background:#FFF url(./bankImage/zhaoshang_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .ABC-NET { background:#FFF url(./bankImage/nongye_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .CCB-NET { background:#FFF url(./bankImage/jianshe_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .CEB-NET { background:#FFF url(./bankImage/guangda_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .BOCO-NET { background:#FFF url(./bankImage/jiaotong_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .CMBC-NET { background:#FFF url(./bankImage/minsheng_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .SDB-NET { background:#FFF url(./bankImage/shenzhenfazhan_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .BCCB-NET { background:#FFF url(./bankImage/beijing_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .CIB-NET { background:#FFF url(./bankImage/xingye_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .ECITIC-NET { background:#FFF url(./bankImage/zhongxin_bank.gif) no-repeat 0px center; }
	.ui-list-icons li .SPDB-NET { background:#FFF url(./bankImage/pufa_bank.gif) no-repeat 0px center; }
	/* Bank Submit */ 
	.paybok { padding:0px 0px 0px 20px; } 
	.paybok .csbtx { border-radius:3px; color:#FFF; font-weight:bold; } 
</style> 
<script type="text/javascript"> 
	$(function(){ 
		//Bank Hover 
		$('.ui-list-icons > li').hover(function(){ 
		$(this).children('.icon-box').addClass('hover'); 
		}, function(){ 
		$(this).children('.icon-box').removeClass('hover'); 
		}); 
	
		//Bank Click 
		$('.ui-list-icons > li').click(function(){ 
			for ( var i=0; i<$('.ui-list-icons > li').length; i++ ){ 
				$('.ui-list-icons > li').eq(i).children('.icon-box').removeClass('current'); 
			} 
			$(this).children('.icon-box').addClass('current'); 
		}); 
	});
	function checkOnlinePayment(form){
		if(isNaN(form.orderID.value) || form.orderID.value==""){
			alert("订单号不能为空且为数字!");
			form.orderID.focus();
			return false;
		}
		if(isNaN(form.amount.value) || form.amount.value==""){
			alert("金钱不能为空且为数字!");
			form.amount.focus();
			return false;
		}
		if(isNaN(form.accountID.value) || form.accountID.value==""){
			alert("汇款商户不能为空且为数字!");
			return false;
		}
		return true;
	}
	window.onload = function(){
		//document.getElementById("accountID").value = parent.accountID;
		//document.getElementById("keyValue").value = parent.keyValue;
	};
</script> 
</head> 
<body> 
<div class="paying"> 
	<p class="paytit"> 
		<strong>在线支付</strong> 
		<span>欢迎您登录本系统</span> 
		<b style="float:right; color: red">请选择相应的银行:</b>
	</p> 
	<form action="PaymentSendServlet" method="POST" class="validator" target="_blank"> 
		<div class="payamont"> 
			<div style="float:left;" >
				<b>订单号：</b><input type="text" name="orderID" placeholder="任意订单号">
			</div>  
			<div style="float:left; margin-left: 40px;" >
				<b>应付金额：￥</b><input type="text" id="amount" name="amount" style="width:50px" placeholder="RMB"/>
			</div>
			<div style="float:left; margin-left: 40px;" >
				<b>汇款商户：</b><input type="text" id="accountID" name="accountID" style="width:205px" readonly="readonly" value="12321"/>
				<input type="hidden" id="keyValue" name="keyValue" value="">
			</div>
		</div> 
		<div class="clr"></div> 
		<ul class="ui-list-icons clrfix"> 
			<li> 
				<input type="radio" name="pd_FrpId" value="ICBC-NET" id="ICBC-NET" checked="checked"> 
				<label class="icon-box current" for="ICBC-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon ICBC-NET" title="工商银行"></span> 
					<span class="bank-name">工商银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="CMBCHINA-NET" id="CMBCHINA-NET"> 
				<label class="icon-box" for="CMBCHINA-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon CMBCHINA-NET" title="招商银行"></span> 
					<span class="bank-name">招商银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="ABC-NET" id="ABC-NET"> 
				<label class="icon-box" for="ABC-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon ABC-NET" title="农业银行"></span> 
					<span class="bank-name">农业银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="CCB-NET" id="CCB-NET"> 
				<label class="icon-box" for="CCB-NET"> 
						<span class="icon-box-sparkling" bbd="false"> </span> 
						<span class="false icon CCB-NET" title="中国建设银行"></span> 
						<span class="bank-name">中国建设银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="CEB-NET" id="CEB-NET"> 
				<label class="icon-box" for="CEB-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon CEB-NET" title="光大银行"></span> 
					<span class="bank-name">光大银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="BOCO-NET" id="BOCO-NET" > 
				<label class="icon-box" for="BOCO-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon BOCO-NET" title="交通银行"></span> 
					<span class="bank-name">交通银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="CMBC-NET" id="CMBC-NET" > 
				<label class="icon-box" for="CMBC-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon CMBC-NET" title="民生银行"></span> 
					<span class="bank-name">民生银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="SDB-NET" id="SDB-NET" > 
				<label class="icon-box" for="SDB-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon SDB-NET" title="深圳发展银行"></span> 
					<span class="bank-name">深圳发展银行</span> 
				</label> 
			</li> 
			<li> 
				<input type="radio" name="pd_FrpId" value="BCCB-NET" id="BCCB-NET" > 
				<label class="icon-box" for="BCCB-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon BCCB-NET" title="北京银行"></span> 
					<span class="bank-name">北京银行</span> 
				</label> 
			</li> 
			<li> 
			<input type="radio" name="pd_FrpId" value="CIB-NET" id="CIB-NET"> 
				<label class="icon-box" for="CIB-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon CIB-NET" title="兴业银行"></span> 
					<span class="bank-name">兴业银行</span> 
				</label> 
			</li> 
			<li> 
			<input type="radio" name="pd_FrpId" value="ECITIC-NET" id="ECITIC-NET"> 
				<label class="icon-box" for="ECITIC-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon ECITIC-NET" title="中信银行"></span> 
					<span class="bank-name">中信银行</span> 
				</label> 
			</li> 
			<li>
				<input type="radio" name="pd_FrpId" value="SPDB-NET" id="SPDB-NET"> 
				<label class="icon-box" for="SPDB-NET"> 
					<span class="icon-box-sparkling" bbd="false"> </span> 
					<span class="false icon SPDB-NET" title="浦东发展银行"></span> 
					<span class="bank-name">浦东发展银行</span> 
				</label> 
			</li> 
		</ul> 
		<div class="paybok" style="margin-top: 10px;">
			<input class="csbtx" type="submit" value="确认支付" onclick="return checkOnlinePayment(this.form);">
		</div> 
	</form> 
</div> 

</body> 
</html>