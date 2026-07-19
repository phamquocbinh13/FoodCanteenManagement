import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/analytics_metrics.dart';

class WeatherForecastWidget extends StatelessWidget {
  const WeatherForecastWidget({super.key, required this.forecastDays});

  final List<WeatherDay> forecastDays;

  IconData _getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_rounded;
    if (code >= 1 && code <= 3) return Icons.cloud_rounded;
    if (code == 45 || code == 48) return Icons.foggy;
    if (code >= 51 && code <= 67) return Icons.water_drop_rounded;
    if (code >= 71 && code <= 77) return Icons.ac_unit_rounded;
    if (code >= 80 && code <= 82) return Icons.water_drop_rounded;
    if (code >= 95) return Icons.flash_on_rounded;
    return Icons.cloud_rounded;
  }

  @override
  Widget build(BuildContext context) {
    if (forecastDays.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            '7-DAY FORECAST',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: const Color(0xFF829289), // Ink Muted
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            scrollDirection: Axis.horizontal,
            itemCount: forecastDays.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final day = forecastDays[index];
              final date = DateTime.tryParse(day.date) ?? DateTime.now();
              final isToday = index == 0;
              final dayName = isToday ? 'TODAY' : DateFormat('EEE').format(date).toUpperCase();

              return Container(
                width: 72,
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFF1A221E) : const Color(0xFF121815),
                  borderRadius: BorderRadius.circular(12),
                  border: isToday ? Border.all(color: const Color(0xFFC5A880).withValues(alpha: 0.3)) : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                        color: isToday ? const Color(0xFFC5A880) : const Color(0xFF829289),
                      ),
                    ),
                    Icon(
                      _getWeatherIcon(day.weatherCode),
                      color: const Color(0xFFE6EBE7),
                      size: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${day.tempMax}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE6EBE7),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${day.tempMin}°',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF829289),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
