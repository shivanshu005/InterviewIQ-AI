package ai.interviewiq.api.controller;
import ai.interviewiq.api.dto.AnalyticsDtos.OverviewResponse; import ai.interviewiq.api.service.AnalyticsService; import org.springframework.security.core.Authentication; import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/v1/analytics") public class AnalyticsController { private final AnalyticsService service; public AnalyticsController(AnalyticsService s){service=s;} @GetMapping("/overview") OverviewResponse overview(Authentication a){return service.overview((Long)a.getPrincipal());} }
