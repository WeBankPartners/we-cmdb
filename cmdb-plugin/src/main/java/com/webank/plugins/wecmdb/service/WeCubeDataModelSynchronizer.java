package com.webank.plugins.wecmdb.service;

import com.webank.plugins.wecmdb.config.PluginApplicationProperties;
import com.webank.plugins.wecmdb.dto.wecube.WeCubeDataModelDto;
import com.webank.plugins.wecmdb.dto.wecube.WeCubeDataModelResponseDto;
import org.checkerframework.checker.units.qual.A;
import org.reactivestreams.Publisher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.ClientRequest;
import org.springframework.web.reactive.function.client.ClientResponse;
import org.springframework.web.reactive.function.client.ExchangeFunction;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import javax.annotation.PostConstruct;

@Service
public class WeCubeDataModelSynchronizer {
    private final static Logger logger = LoggerFactory.getLogger(WeCubeDataModelSynchronizer.class);

    private final WebClient webClient;

    @Autowired
    public WeCubeDataModelSynchronizer(PluginApplicationProperties pluginApplicationProperties) {
        webClient = WebClient.builder()
                .baseUrl(pluginApplicationProperties.getGatewayUrl())
                .filter(this::addAuthToken)
                .build();
    }

    public Mono<String> synchronize() {
        Mono<WeCubeDataModelDto> dataModelMono = getDataModelFromWeCube();
        return applyDataModelOnWeCube(dataModelMono)
                .doOnSuccess(body -> logger.info("Successfully synchronized data model to WeCube."))
                .doOnError(e -> logger.error("Error occurred when synchronizing data model to WeCube.", e));
    }

    private Mono<ClientResponse> addAuthToken(ClientRequest request, ExchangeFunction next) {
        SecurityContext context = SecurityContextHolder.getContext();
        if(context == null) return next.exchange(request);

        Authentication authentication = context.getAuthentication();
        if(authentication == null) return next.exchange(request);

        String authToken = String.valueOf(authentication.getCredentials());
        ClientRequest requestWithAuthToken = ClientRequest.from(request)
                .header("Authorization", authToken)
                .build();
        return next.exchange(requestWithAuthToken);
    }

    private Mono<WeCubeDataModelDto> getDataModelFromWeCube() {
        return webClient.get()
                .uri("/platform/v1/models/package/wecmdb")
                .accept(MediaType.APPLICATION_JSON)
                .retrieve()
                .bodyToMono(WeCubeDataModelResponseDto.class)
                .log()
                .map(WeCubeDataModelResponseDto::getData);
    }

    private Mono<String> applyDataModelOnWeCube(Publisher<WeCubeDataModelDto> dataModelMono) {
        return webClient.post()
                .uri("/platform/v1/models")
                .contentType(MediaType.APPLICATION_JSON)
                .body(dataModelMono, WeCubeDataModelDto.class)
                .retrieve()
                .bodyToMono(String.class)
                .log();
    }
}
