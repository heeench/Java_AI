package com.example.demo.controller;

import com.example.demo.sentiment.JsonSentimentAnalyzer;
import com.example.demo.sentiment.SentimentAnalyzer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SentimentController {

    private final SentimentAnalyzer analyzer;

    public SentimentController(JsonSentimentAnalyzer analyzer) {
        this.analyzer = analyzer;
    }

    @GetMapping("/api/sentiment")
    public String getSentiment(@RequestParam String text) {
        String sentiment = analyzer.analyze(text);
        return "{\"text\":\"" + text + "\", \"sentiment\":\"" + sentiment + "\"}";
    }
}
