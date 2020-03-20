package com.webank.plugins.wecmdb.helper;


import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.net.ssl.KeyManager;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.client.LaxRedirectStrategy;
import org.apache.http.message.BasicHeader;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import com.alibaba.fastjson.JSON;

/**
 * HttpUtils工具类
 *
 * @author
 *
 */
public class HttpUtils {

    /**
     * 请求方式：post
     */
    public static String POST = "post";

    /**
     * 编码格式：utf-8
     */
    private static final String CHARSET_UTF_8 = "UTF-8";

    /**
     * 报文头部json
     */
    private static final String APPLICATION_JSON = "application/json";

    /**
     * 请求超时时间
     */
    private static final int CONNECT_TIMEOUT = 60 * 1000;

    /**
     * 传输超时时间
     */
    private static final int SO_TIMEOUT = 60 * 1000;

    /**
     *
     * @param protocol
     * @param url
     * @param paraMap
     * @return
     * @throws Exception
     */
    public static String doPost(String protocol, String url,
                                Map<String, Object> paraMap) throws Exception {
        CloseableHttpClient httpClient = null;
        CloseableHttpResponse resp = null;
        String rtnValue = null;
        try {
            if (protocol.equals("http")) {
                httpClient = HttpClients.createDefault();
            } else {
                // 获取https安全客户端
                httpClient = HttpUtils.getHttpsClient();
            }

            HttpPost httpPost = new HttpPost(url);
            List<NameValuePair> list = new ArrayList<NameValuePair>();
            if (null != paraMap && paraMap.size() > 0) {
                for (Entry<String, Object> entry : paraMap.entrySet()) {
                    list.add(new BasicNameValuePair(entry.getKey(), entry
                            .getValue().toString()));
                }
            }

            RequestConfig requestConfig = RequestConfig.custom()
                    .setSocketTimeout(SO_TIMEOUT)
                    .setConnectTimeout(CONNECT_TIMEOUT).build();// 设置请求和传输超时时间
            httpPost.setConfig(requestConfig);
            httpPost.setEntity(new UrlEncodedFormEntity(list, CHARSET_UTF_8));
            resp = httpClient.execute(httpPost);
            rtnValue = EntityUtils.toString(resp.getEntity(), CHARSET_UTF_8);

        } catch (Exception e) {
            throw e;
        } finally {
            if (null != resp) {
                resp.close();
            }
            if (null != httpClient) {
                httpClient.close();
            }
        }

        return rtnValue;
    }

    /**
     * 获取https，单向验证
     *
     * @return
     * @throws Exception
     */
    public static CloseableHttpClient getHttpsClient() throws Exception {
        try {
            TrustManager[] trustManagers = new TrustManager[] { new X509TrustManager() {
                public void checkClientTrusted(
                        X509Certificate[] paramArrayOfX509Certificate,
                        String paramString) throws CertificateException {
                }

                public void checkServerTrusted(
                        X509Certificate[] paramArrayOfX509Certificate,
                        String paramString) throws CertificateException {
                }

                public X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
            } };
            SSLContext sslContext = SSLContext
                    .getInstance(SSLConnectionSocketFactory.TLS);
            sslContext.init(new KeyManager[0], trustManagers,
                    new SecureRandom());
            SSLContext.setDefault(sslContext);
            sslContext.init(null, trustManagers, null);
            SSLConnectionSocketFactory connectionSocketFactory = new SSLConnectionSocketFactory(
                    sslContext,
                    SSLConnectionSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
            HttpClientBuilder clientBuilder = HttpClients.custom()
                    .setSSLSocketFactory(connectionSocketFactory);
            clientBuilder.setRedirectStrategy(new LaxRedirectStrategy());
            CloseableHttpClient httpClient = clientBuilder.build();
            return httpClient;
        } catch (Exception e) {
            throw new Exception("http client 远程连接失败", e);
        }
    }

    /**
     * post请求
     *
     * @param msgs
     * @param url
     * @return
     * @throws ClientProtocolException
     * @throws UnknownHostException
     * @throws IOException
     */
    public static String post(Map<String, Object> msgs, String url)
            throws ClientProtocolException, UnknownHostException, IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        try {
            HttpPost request = new HttpPost(url);
            List<NameValuePair> valuePairs = new ArrayList<NameValuePair>();
            if (null != msgs) {
                for (Entry<String, Object> entry : msgs.entrySet()) {
                    if (entry.getValue() != null) {
                        valuePairs.add(new BasicNameValuePair(entry.getKey(),
                                entry.getValue().toString()));
                    }
                }
            }
            request.setEntity(new UrlEncodedFormEntity(valuePairs, CHARSET_UTF_8));
            CloseableHttpResponse resp = httpClient.execute(request);
            return EntityUtils.toString(resp.getEntity(), CHARSET_UTF_8);
        } finally {
            httpClient.close();
        }
    }

    /**
     * get请求
     *
     * @param msgs
     * @param url
     * @return
     * @throws ClientProtocolException
     * @throws UnknownHostException
     * @throws IOException
     */
    public static String get(Map<String, Object> msgs, String url)
            throws ClientProtocolException, UnknownHostException, IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        try {
            List<NameValuePair> valuePairs = new ArrayList<NameValuePair>();
            if (null != msgs) {
                for (Entry<String, Object> entry : msgs.entrySet()) {
                    if (entry.getValue() != null) {
                        valuePairs.add(new BasicNameValuePair(entry.getKey(),
                                entry.getValue().toString()));
                    }
                }
            }
            // EntityUtils.toString(new UrlEncodedFormEntity(valuePairs),
            // CHARSET);
            url = url + "?" + URLEncodedUtils.format(valuePairs, CHARSET_UTF_8);
            HttpGet request = new HttpGet(url);
            CloseableHttpResponse resp = httpClient.execute(request);
            return EntityUtils.toString(resp.getEntity(), CHARSET_UTF_8);
        } finally {
            httpClient.close();
        }
    }

    public static <T> T post(Map<String, Object> msgs, String url,
                                   Class<T> clazz) throws ClientProtocolException,
            UnknownHostException, IOException {
        String json = HttpUtils.post(msgs, url);
        T t = JSON.parseObject(json, clazz);
        return t;
    }

    public static <T> T get(Map<String, Object> msgs, String url, Class<T> clazz)
            throws ClientProtocolException, UnknownHostException, IOException {
        String json = HttpUtils.get(msgs, url);
        T t = JSON.parseObject(json, clazz);
        return t;
    }

    public static String postWithJson(Map<String, Object> msgs, String url)
            throws ClientProtocolException, IOException {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        try {
            String jsonParam = JSON.toJSONString(msgs);

            HttpPost post = new HttpPost(url);
            post.setHeader("Content-Type", APPLICATION_JSON);
            post.setEntity(new StringEntity(jsonParam, CHARSET_UTF_8));
            CloseableHttpResponse response = httpClient.execute(post);

            return new String(EntityUtils.toString(response.getEntity()).getBytes("iso8859-1"),CHARSET_UTF_8);
        } finally {
            httpClient.close();
        }
    }

    public static <T> T postWithJson(Map<String, Object> msgs, String url,
                                           Class<T> clazz) throws ClientProtocolException,
            UnknownHostException, IOException {
        String json = HttpUtils.postWithJson(msgs, url);
        T t = JSON.parseObject(json, clazz);
        return t;
    }
 
}
