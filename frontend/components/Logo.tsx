import React from 'react';
import { Svg, Ellipse, Text, G } from 'react-native-svg';

export default function Logo({ 
  width = 260, 
  height = 145,
  showText = true 
}: { 
  width?: number; 
  height?: number;
  showText?: boolean;
}) {
  return (
    <Svg width={width} height={height} viewBox="0 0 428 160" fill="none">
      <G>
        <Ellipse 
          cx="214" 
          cy="78" 
          rx="42" 
          ry="41" 
          fill="#1C8EDA" 
        />

        {showText && (
          <Text
            x="214"
            y="152"
            fill="#0F172A"
            fontSize="36"
            fontWeight="700"
            fontFamily="System"
            textAnchor="middle"           
            alignmentBaseline="middle"
          >
            Yudeel
          </Text>
        )}
      </G>
    </Svg>
  );
}