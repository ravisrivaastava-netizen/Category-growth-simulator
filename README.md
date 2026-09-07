from src.simulator import CategoryGrowthSimulator
from src.visualizations import GrowthVisualizer
import pandas as pd

# 1. Base Configuration
base_config = {
    'category_size': 15000000,
    'penetration': 0.12,
    'frequency': 4.2,
    'distribution': 0.65,
    'average_price': 150,
    'premium_mix': 0.18,
    'market_share': 0.18,
    'households': 35000000,
    'retailers': 50000,
    'margin_rate': 0.45,
    'variable_costs': 0.30
}

# 2. Define All 6 Scenarios
scenarios = [
    {
        'name': 'Base Case',
        'penetration_multiplier': 1.0,
        'frequency_multiplier': 1.0,
        'distribution_multiplier': 1.0,
        'pricing_multiplier': 1.0,
        'premium_mix_multiplier': 1.0,
        'investment': 0
    },
    {
        'name': 'Penetration Focus',
        'penetration_multiplier': 1.15,
        'frequency_multiplier': 1.0,
        'distribution_multiplier': 1.0,
        'pricing_multiplier': 1.0,
        'premium_mix_multiplier': 1.0,
        'investment': 30000000
    },
    {
        'name': 'Distribution Focus',
        'penetration_multiplier': 1.0,
        'frequency_multiplier': 1.0,
        'distribution_multiplier': 1.20,
        'pricing_multiplier': 1.0,
        'premium_mix_multiplier': 1.0,
        'investment': 20000000
    },
    {
        'name': 'Frequency Focus',
        'penetration_multiplier': 1.0,
        'frequency_multiplier': 1.10,
        'distribution_multiplier': 1.0,
        'pricing_multiplier': 1.0,
        'premium_mix_multiplier': 1.0,
        'investment': 15000000
    },
    {
        'name': 'Premiumization',
        'penetration_multiplier': 1.0,
        'frequency_multiplier': 1.0,
        'distribution_multiplier': 1.0,
        'pricing_multiplier': 1.18,
        'premium_mix_multiplier': 1.50,
        'investment': 15000000
    },
    {
        'name': 'Combined Growth',
        'penetration_multiplier': 1.12,
        'frequency_multiplier': 1.05,
        'distribution_multiplier': 1.15,
        'pricing_multiplier': 1.08,
        'premium_mix_multiplier': 1.30,
        'investment': 50000000
    }
]

# 3. Initialize and Run
sim = CategoryGrowthSimulator(base_config)
results = sim.run_scenarios(scenarios)

# 4. Compare Results
comparison_df = sim.compare_scenarios(results)

# 5. Calculate Impacts
base_result = results[0]
impacts = []
for result in results[1:]:
    impact = sim.calculate_impact(base_result, result)
    impacts.append({
        'Scenario': result.name,
        'Volume Growth %': impact['volume_change_pct'],
        'Revenue Growth %': impact['revenue_change_pct'],
        'ROI': result.roi,
        'Market Share Change pp': impact['market_share_change']
    })

impact_df = pd.DataFrame(impacts)

# 6. Generate Visualizations
viz = GrowthVisualizer()
fig1 = viz.plot_roi_comparison(comparison_df)
fig1.savefig('roi_comparison.png', dpi=300, bbox_inches='tight')

fig2 = viz.plot_scenario_comparison(comparison_df, 
                                   metrics=['Volume', 'Revenue', 'Net Profit'])
fig2.savefig('scenario_comparison.png', dpi=300, bbox_inches='tight')

# 7. Export Results
sim.export_results(results, 'nectar_syrup_scenarios.xlsx')

# 8. Print Summary
print("\n" + "="*80)
print("COMPARISON TABLE:")
print(comparison_df.to_string(index=False))

print("\n" + "="*80)
print("IMPACT ANALYSIS:")
print(impact_df.to_string(index=False))

print("\n" + "="*80)
print("STRATEGIC RECOMMENDATIONS:")

best_roi = max(results[1:], key=lambda x: x.roi)
print(f"\n🏆 BEST ROI: {best_roi.name} ({best_roi.roi:.1f}x ROI)")

best_revenue = max(results[1:], key=lambda x: x.revenue)
print(f"💰 HIGHEST REVENUE: {best_revenue.name} (₹{best_revenue.revenue:,.0f})")

best_growth = max(results[1:], key=lambda x: x.market_share)
print(f"📈 HIGHEST GROWTH: {best_growth.name} (+{((best_growth.market_share - base_result.market_share)*100):.1f}pp market share)")