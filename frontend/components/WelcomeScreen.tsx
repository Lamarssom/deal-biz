import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { useRouter } from 'expo-router';
import { Feather } from '@expo/vector-icons';
import { welcomeStyles } from '../styles/welcome.styles';

export default function WelcomeScreen() {
  const router = useRouter();

  return (
    <View style={welcomeStyles.container}>
      {/* Centered Content */}
      <View style={welcomeStyles.centerContent}>
        {/* Checkmark Only - No Logo */}
        <View style={welcomeStyles.checkContainer}>
          <View style={welcomeStyles.checkCircle}>
            <Feather name="check" size={68} color="white" />
          </View>
        </View>
      </View>

      {/* Bottom Content */}
      <View style={welcomeStyles.bottomContent}>
        <Text style={welcomeStyles.welcomeText}>Welcome, Chief!</Text>

        <Text style={welcomeStyles.subtitle}>
          Start exploring sharp deals close to you.
        </Text>

        <TouchableOpacity
          style={welcomeStyles.button}
          activeOpacity={0.9}
          onPress={() => router.replace('/home')}
        >
          <Text style={welcomeStyles.buttonText}>Continue</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}