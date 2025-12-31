package com.yourcompany.netbarmanager.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * 字符编码过滤器
 * 统一设置请求和响应的字符编码为UTF-8
 */
@WebFilter(filterName = "CharacterEncodingFilter", urlPatterns = "/*")
public class CharacterEncodingFilter implements Filter {

    private String encoding = "UTF-8";
    private boolean forceEncoding = false;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 从配置中获取编码参数
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.isEmpty()) {
            this.encoding = encodingParam;
        }

        // 从配置中获取是否强制编码参数
        String forceEncodingParam = filterConfig.getInitParameter("forceEncoding");
        if (forceEncodingParam != null && !forceEncodingParam.isEmpty()) {
            this.forceEncoding = Boolean.parseBoolean(forceEncodingParam);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // 设置请求字符编码
        if (forceEncoding || request.getCharacterEncoding() == null) {
            request.setCharacterEncoding(encoding);
        }

        // 设置响应字符编码
        response.setCharacterEncoding(encoding);

        // 设置响应内容类型
        if (response.getContentType() == null) {
            response.setContentType("text/html; charset=" + encoding);
        }

        // 继续执行过滤器链
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 清理资源
        this.encoding = null;
    }
}