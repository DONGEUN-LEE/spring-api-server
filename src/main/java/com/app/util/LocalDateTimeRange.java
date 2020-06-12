package com.app.util;

import java.time.LocalDateTime;
import static java.util.Objects.*;

public class LocalDateTimeRange {

  private final LocalDateTime from;
  private final LocalDateTime to;

  public LocalDateTimeRange(LocalDateTime from, LocalDateTime to) {
    requireNonNull(from, "from must not be null");
    requireNonNull(to, "to must not be null");
    this.from = from;
    this.to = to;
  }

  public boolean overlaps(LocalDateTimeRange other) {
    requireNonNull(other, "other must not be null");
    return from.isBefore(other.to) && other.from.isBefore(to);
  }
}
