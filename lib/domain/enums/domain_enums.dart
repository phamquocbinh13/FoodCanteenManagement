import 'package:json_annotation/json_annotation.dart';

/// Operational status of a physical dine-in [RestaurantTable].
///
/// No `cleaning` status per PROJECT_CONTEXT. [occupied] only returns to
/// [available] after session payment or admin force-close.
enum TableStatus {
  @JsonValue('available')
  available,
  @JsonValue('occupied')
  occupied,
  @JsonValue('reserved')
  reserved,
}

/// Lifecycle of a dine-in [DineInSession].
///
/// Maps to sprint lifecycle phases:
/// [open] → Occupied, [paymentPending] → WaitingPayment, [closed] → Closed.
enum SessionStatus {
  @JsonValue('open')
  open,
  @JsonValue('payment_pending')
  paymentPending,
  @JsonValue('closed')
  closed,
}

/// Payment summary status on an open session (not terminal [SessionPayment]).
enum SessionPaymentStatus {
  @JsonValue('unpaid')
  unpaid,
  @JsonValue('waiting_payment')
  waitingPayment,
  @JsonValue('paid')
  paid,
}

/// Semantic lifecycle phases for session state machine (never compare in UI).
enum SessionLifecyclePhase {
  available,
  occupied,
  waitingPayment,
  closed,
}

/// Extension point for future session merge — not implemented in MVP.
enum SessionMergeCapability {
  unsupported,
}

/// How a dine-in session was started.
enum SessionOpenedVia {
  @JsonValue('qr_scan')
  qrScan,
  @JsonValue('cashier_manual')
  cashierManual,
}

/// Append-only timeline events stored on a [DineInSession].
enum SessionTimelineEventType {
  @JsonValue('session_opened')
  sessionOpened,
  @JsonValue('device_joined')
  deviceJoined,
  @JsonValue('cart_item_added')
  cartItemAdded,
  @JsonValue('cart_item_removed')
  cartItemRemoved,
  @JsonValue('batch_confirmed')
  batchConfirmed,
  @JsonValue('staff_request_created')
  staffRequestCreated,
  @JsonValue('staff_request_handled')
  staffRequestHandled,
  @JsonValue('payment_requested')
  paymentRequested,
  @JsonValue('payment_closed')
  paymentClosed,
  @JsonValue('session_force_closed')
  sessionForceClosed,
}

/// Kitchen and customer-visible progress per [BatchItem].
enum BatchItemStatus {
  @JsonValue('preparing')
  preparing,
  @JsonValue('completed')
  completed,
  @JsonValue('served')
  served,
}

/// Customer call-staff request category (request queue).
enum RequestType {
  @JsonValue('payment')
  payment,
  @JsonValue('staff_assistance')
  staffAssistance,
  @JsonValue('extra_water')
  extraWater,
  @JsonValue('extra_bowl')
  extraBowl,
  @JsonValue('extra_spoon')
  extraSpoon,
}

/// Cashier handling state for [StaffRequest].
enum RequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('handled')
  handled,
  @JsonValue('cancelled')
  cancelled,
}

/// Non-dine-in channel discriminator for [RomsOrder].
///
/// Dine-in uses [DineInSession], never [RomsOrder].
enum OrderType {
  @JsonValue('takeaway')
  takeaway,
  @JsonValue('delivery')
  delivery,
}

/// Macro lifecycle for [RomsOrder] (takeaway/delivery).
enum OrderStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('submitted')
  submitted,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('ready')
  ready,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Shipper micro-lifecycle on [DeliveryDetail].
enum DeliveryStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('ready')
  ready,
  @JsonValue('claimed')
  claimed,
  @JsonValue('delivering')
  delivering,
  @JsonValue('completed')
  completed,
  @JsonValue('unassigned')
  unassigned,
}

/// Kitchen-controlled catalog visibility for [MenuItem].
enum MenuAvailability {
  @JsonValue('available')
  available,
  @JsonValue('out_of_stock')
  outOfStock,
}

/// How a [CustomizationGroup] selection behaves.
enum CustomizationSelectionType {
  @JsonValue('single_select')
  singleSelect,
  @JsonValue('multi_select')
  multiSelect,
  @JsonValue('boolean')
  boolean,
}

/// Payment instrument recorded at session/order close.
enum PaymentMethod {
  @JsonValue('cash')
  cash,
  @JsonValue('card')
  card,
  @JsonValue('bank_transfer')
  bankTransfer,
  @JsonValue('other')
  other,
}

/// How a dine-in session was terminated.
enum SessionCloseType {
  @JsonValue('payment')
  payment,
  @JsonValue('force_closed')
  forceClosed,
}

/// Required reason when admin force-closes a session.
enum ForceCloseReason {
  @JsonValue('customer_left')
  customerLeft,
  @JsonValue('dispute')
  dispute,
  @JsonValue('system_error')
  systemError,
  @JsonValue('other')
  other,
}

/// Staff role keys for RBAC.
enum RoleKey {
  @JsonValue('admin')
  admin,
  @JsonValue('manager')
  manager,
  @JsonValue('cashier')
  cashier,
  @JsonValue('kitchen')
  kitchen,
  @JsonValue('shipper')
  shipper,
}

/// Who performed a domain action (audit, timeline, batch confirm).
enum ActorType {
  @JsonValue('user')
  user,
  @JsonValue('customer_session')
  customerSession,
  @JsonValue('system')
  system,
}

/// Append-only audit action types for [AuditLog].
enum AuditAction {
  @JsonValue('create')
  create,
  @JsonValue('update')
  update,
  @JsonValue('delete')
  delete,
  @JsonValue('status_change')
  statusChange,
  @JsonValue('close')
  close,
  @JsonValue('claim')
  claim,
  @JsonValue('reassign')
  reassign,
  @JsonValue('force_close')
  forceClose,
}
