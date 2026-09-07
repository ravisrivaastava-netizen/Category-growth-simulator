# Category Growth Simulator

**Marketing × Analytics × Strategy**

A fully functional scenario modeling tool for Category Managers and Marketing Leaders to test growth levers, quantify commercial impact, and optimize investment decisions.

> **Status: ✅ Complete Implementation**  
> All stages (A-G) are fully implemented and ready for use.

> This repository is a portfolio prototype. All company, brand and dataset examples are fictional and created for demonstration/testing.

---

## 🚀 What This Project Does

The Category Growth Simulator helps marketing teams:

1. **Test growth scenarios** before committing investment
2. **Quantify commercial impact** of strategic choices
3. **Compare trade-offs** across different growth levers
4. **Build commercial confidence** through data-backed modeling
5. **Challenge assumptions** about growth constraints
6. **Optimize investment allocation** for maximum ROI
7. **Visualize outcomes** through interactive dashboards

---

## The Problem

Marketing leaders face constant pressure to grow, but:

- **"What if we increase distribution?"** → Unknown volume impact
- **"What if we premiumize?"** → Unknown margin trade-off
- **"What if we launch a new SKU?"** → Unknown cannibalization
- **"What if we invest in penetration?"** → Unknown ROI
- **"How much should we invest?"** → Unknown optimal budget

The Simulator takes the guesswork out of growth decisions by modeling the interconnected impact of commercial levers on revenue, volume, and margin.

---

## Strategic Philosophy

The Simulator is built on five principles:

1. **Model before you invest** — Test scenarios virtually before committing real resources
2. **Connect levers to P&L** — Every growth lever must connect to revenue and margin
3. **Understand trade-offs** — Growth in one area may come at the expense of another
4. **Challenge assumptions** — Model should reveal, not hide, key assumptions
5. **Build commercial confidence** — Results should be actionable, not academic

---

## Growth Lever Architecture

The Simulator models 9 key growth levers:

### 1. Penetration
- **Definition:** % of target households buying the brand
- **Impact:** New buyers = volume growth
- **Levers:** Awareness, consideration, trial, distribution

### 2. Frequency
- **Definition:** Purchases per buyer per period
- **Impact:** More repeat = sustainable volume
- **Levers:** Occasion expansion, loyalty, pack size

### 3. Distribution
- **Definition:** % of outlets carrying the brand
- **Impact:** Availability = trial opportunity
- **Levers:** Channel expansion, shelf presence

### 4. Pricing
- **Definition:** Price point vs. competitors
- **Impact:** Volume vs. margin trade-off
- **Levers:** Price positioning, promotions

### 5. Pack Mix
- **Definition:** Distribution of pack sizes
- **Impact:** Average transaction value
- **Levers:** Pack architecture, size expansion

### 6. Premium Mix
- **Definition:** % of sales from premium SKUs
- **Impact:** Margin expansion
- **Levers:** Premiumization, portfolio mix

### 7. Market Share
- **Definition:** % of category sales
- **Impact:** Competitive position
- **Levers:** All of the above

### 8. Occasion Expansion
- **Definition:** Number of usage occasions
- **Impact:** Frequency + penetration
- **Levers:** New use cases, communication

### 9. Geographic Expansion
- **Definition:** New markets entered
- **Impact:** Total addressable market growth
- **Levers:** New regions, distribution build

---

## Simulator Architecture

### Input Variables

```python
{
    "category_size": 1000000,          # Total category volume
    "penetration": 0.25,               # Household penetration
    "frequency": 3.5,                  # Purchases per buyer
    "distribution": 0.70,              # % outlets stocked
    "average_price": 150,              # Weighted average price
    "premium_mix": 0.15,               # % premium SKUs
    "market_share": 0.18,              # Brand share of category
    "households": 35000000,            # Target household base
    "retailers": 50000,                # Total outlet universe
    "margin_rate": 0.45,               # Gross margin %
    "variable_costs": 0.30             # Variable costs as % of revenue
}