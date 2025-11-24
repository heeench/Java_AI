package com.example.demo.sentiment;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.Iterator;
import java.util.Map;

@Component
public class JsonSentimentAnalyzer implements SentimentAnalyzer {
    private JsonNode sentiments;

    public JsonSentimentAnalyzer() {
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("sentiments.json")) {
            if (is == null) {
                throw new RuntimeException("sentiments.json not found in resources");
            }
            ObjectMapper mapper = new ObjectMapper();
            sentiments = mapper.readTree(is);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public String analyze(String text) {
        text = text.toLowerCase();
        Iterator<Map.Entry<String, JsonNode>> fields = sentiments.fields();
        while (fields.hasNext()) {
            Map.Entry<String, JsonNode> entry = fields.next();
            for (JsonNode word : entry.getValue()) {
                if (text.contains(word.asText())) {
                    return entry.getKey();
                }
            }
        }
        return "neutral";
    }
}