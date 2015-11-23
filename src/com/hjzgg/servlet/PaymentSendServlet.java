package com.hjzgg.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
  
import com.hjzgg.util.PaymentUtil;  
  
/** 
 * 发起支付请求 
 * @see ============================================================================================== 
 * @see 测试商户 
 * @see p1_MerId=10000432521 
 * @see keyValue=8UPp0KE8sq73zVP370vko7C39403rtK1YwX40Td6irH216036H27Eb12792t 
 * @see ============================================================================================== 
 * @see 正式商户：本人亲测，可以直接连到银行页面 
 * @see p1_MerId=10001126856 
 * @see keyValue=69cl522AV6q613Ii4W6u8K6XuW8vM1N6bFgyv769220IuYe9u37N4y7rI4Pl 
 * @see ============================================================================================== 
 * @see accountCallbackURL=http://127.0.0.1:8088/payment/servlet/yeepay/PaymentResultServlet 
 * @see 此时机器需联网。若使用路由上的网，只要把路由的IP写进去，再在路由里配置一个8088端口的转发规则，即可 
 * @see ============================================================================================== 
 */  
 
/**
 * Servlet implementation class PaymentSendServlet
 */
@WebServlet("/PaymentSendServlet")
public class PaymentSendServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PaymentSendServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		process(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		process(request, response);
	}
	
	private void process(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GBK");  
        
        //测试商户：商户编号  
        String accountID = "10001126856";  
        //测试商户：密钥  
        String keyValue = "69cl522AV6q613Ii4W6u8K6XuW8vM1N6bFgyv769220IuYe9u37N4y7rI4Pl";  
        //测试商户：商户接收支付成功数据的地址  
        String accountCallbackURL = "http://localhost:8080/OnlinePayment/PaymentResultServlet";  
          
        String orderID = request.getParameter("orderID");        //获取订单号  
        String amount = request.getParameter("amount");          //获取支付金额  
        String accountBankID = request.getParameter("pd_FrpId"); //获取用户所选择的银行  
        String businessType = "Buy";  //业务类型。Buy为在线支付  
        String currency = "CNY";      //交易币种。CNY为人民币  
        String productDesc = "";      //商品描述  
        String productCategory = "";  //商品种类  
        String productID = "";        //商品ID  
        String addressFlag = "0";     //送货地址。0为不需要，1为需要  
        String accountMoreInfo = "";  //商户扩展信息  
        String pr_NeedResponse = "0"; //应答机制  
          
        String md5hmac = PaymentUtil.buildHmac(  
                businessType, accountID, orderID, amount, currency, productID, productCategory,  
                productDesc, accountCallbackURL, addressFlag, accountMoreInfo, accountBankID,  
                pr_NeedResponse, keyValue);  
          
        request.setAttribute("businessType", businessType);  
        request.setAttribute("accountID", accountID);  
        request.setAttribute("orderID", orderID);  
        request.setAttribute("amount", amount);  
        request.setAttribute("currency", currency);  
        request.setAttribute("productID", productID);  
        request.setAttribute("productCategory", productCategory);  
        request.setAttribute("productDesc", productDesc);  
        request.setAttribute("accountCallbackURL", accountCallbackURL);  
        request.setAttribute("addressFlag", addressFlag);  
        request.setAttribute("accountMoreInfo", accountMoreInfo);  
        request.setAttribute("accountBankID", accountBankID);  
        request.setAttribute("needResponse", pr_NeedResponse);  
        request.setAttribute("md5hmac", md5hmac);  
        
        request.getRequestDispatcher("connection.jsp").forward(request, response);  
	}
}
