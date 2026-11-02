package ai.interviewiq.api.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfiguration {
    @Bean
    OpenAPI interviewIqOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("InterviewIQ AI API")
                        .version("v1")
                        .description("Versioned REST API for the InterviewIQ AI platform.")
                        .license(new License().name("MIT")))
                .components(new Components().addSecuritySchemes("bearerAuth",
                        new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")
                                .description("JWT access token returned by the login or registration endpoint.")));
    }
}
